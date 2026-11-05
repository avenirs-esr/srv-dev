#!/bin/bash
# Migrates the files of the local Docker volume to the S3 bucket and rewrites dev.file.uri
# from absolute local paths to bucket keys, without deleting anything.
#
#   ./scripts/migrate-storage-to-s3.sh            dry-run (read-only: SELECTs and HEAD requests)
#   ./scripts/migrate-storage-to-s3.sh --apply    upload, verify, then update the database
#
# Safety:
#  - the volume is mounted read-only and never modified;
#  - existing bucket objects are never overwritten (same size = skipped, other size = CONFLICT);
#  - every upload is verified (size) before its row may be rewritten;
#  - the UPDATE only touches rows whose object is verified in the bucket, in one transaction;
#  - dev.file (id, uri) is exported to a CSV beforehand, which is the rollback source;
#  - the script is idempotent: re-running it only handles what is left.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APPLY=0
[ "${1:-}" = "--apply" ] && APPLY=1

set +u
. "$ROOT/.secrets.env"
. "$ROOT/scripts/srv-dev-env.sh" >/dev/null 2>&1 || true
set -u

die() { echo "ERROR: $*" >&2; exit 1; }

[ "${AVENIRS_PORTFOLIO_STORAGE_BACKEND:-}" = "s3" ] || die "AVENIRS_PORTFOLIO_STORAGE_BACKEND must be s3"
for v in SEC_AVENIRS_PORTFOLIO_API_S3_ENDPOINT SEC_AVENIRS_PORTFOLIO_API_S3_BUCKET \
         SEC_AVENIRS_PORTFOLIO_API_S3_ACCESS_KEY SEC_AVENIRS_PORTFOLIO_API_S3_SECRET_KEY \
         AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME POSTGRES_USER POSTGRES_DB SEC_POSTGRES_PASSWORD; do
  [ -n "${!v:-}" ] || die "$v is empty (check .secrets.env / srv-dev-env.sh)"
done

VOLUME="${STORAGE_VOLUME:-srv-dev_file-storage}"
PG="$AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME"
ADDR="path"; [ "${SEC_AVENIRS_PORTFOLIO_API_S3_PATH_STYLE_ACCESS:-true}" = "false" ] && ADDR="virtual"
BACKUP_DIR="${BACKUP_DIR:-$ROOT/out}"
export MSYS_NO_PATHCONV=1

docker volume inspect "$VOLUME" >/dev/null 2>&1 || die "Docker volume $VOLUME not found"
psql_pg() { docker exec -i -e PGPASSWORD="$SEC_POSTGRES_PASSWORD" "$PG" \
  psql -h localhost -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 -qAt "$@"; }

echo "== Database"
total=$(psql_pg -c "SELECT count(*) FROM dev.file")
local_rows=$(psql_pg -c "SELECT count(*) FROM dev.file WHERE uri LIKE '/%'")
echo "dev.file rows: $total, with a local path: $local_rows, already keys/other: $((total - local_rows))"
[ "$local_rows" -gt 0 ] || { echo "Nothing to migrate."; exit 0; }

names=$(psql_pg -c "SELECT DISTINCT regexp_replace(uri, '^.*/', '') FROM dev.file WHERE uri LIKE '/%' ORDER BY 1" | tr -d '\r')
while IFS= read -r n; do
  [[ "$n" =~ ^[A-Za-z0-9._-]+$ ]] || die "Unexpected file name in database: '$n'"
done <<< "$names"
echo "Distinct files to handle: $(echo "$names" | wc -l)"

if [ "$APPLY" = 1 ]; then
  mkdir -p "$BACKUP_DIR"
  backup="$BACKUP_DIR/dev_file_uri_backup_$(date +%Y%m%d-%H%M%S).csv"
  psql_pg -c "COPY (SELECT id, uri FROM dev.file ORDER BY id) TO STDOUT WITH CSV HEADER" > "$backup"
  [ "$(($(wc -l < "$backup") - 1))" -eq "$total" ] || die "Backup row count mismatch, aborting"
  echo "Backup written: $backup"
fi

echo "== Bucket"
export AWS_ACCESS_KEY_ID="$SEC_AVENIRS_PORTFOLIO_API_S3_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="$SEC_AVENIRS_PORTFOLIO_API_S3_SECRET_KEY"
export AWS_DEFAULT_REGION="${SEC_AVENIRS_PORTFOLIO_API_S3_REGION:-eu-west-3}"
export S3_ENDPOINT="$SEC_AVENIRS_PORTFOLIO_API_S3_ENDPOINT" S3_BUCKET="$SEC_AVENIRS_PORTFOLIO_API_S3_BUCKET"
export S3_ADDR="$ADDR" MODE_APPLY="$APPLY"

result=$(echo "$names" | docker run --rm -i \
  -v "$VOLUME":/data:ro \
  -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION \
  -e S3_ENDPOINT -e S3_BUCKET -e S3_ADDR -e MODE_APPLY \
  --entrypoint sh amazon/aws-cli:2.17.0 -c '
    export AWS_CONFIG_FILE=/tmp/aws.cfg
    printf "[default]\ns3 =\n  addressing_style = %s\n" "$S3_ADDR" > "$AWS_CONFIG_FILE"
    s3api() { aws --endpoint-url "$S3_ENDPOINT" s3api "$@"; }
    s3api head-bucket --bucket "$S3_BUCKET" >/dev/null 2>&1 || { echo "FATAL bucket not reachable"; exit 3; }
    while IFS= read -r n; do
      f="/data/$n"
      [ -f "$f" ] || { echo "MISSING $n"; continue; }
      size=$(stat -c %s "$f")
      remote=$(s3api head-object --bucket "$S3_BUCKET" --key "$n" --query ContentLength --output text 2>/dev/null || true)
      if [ "$remote" = "$size" ]; then echo "OK $n"; continue; fi
      if [ -n "$remote" ]; then echo "CONFLICT $n"; continue; fi
      [ "$MODE_APPLY" = 1 ] || { echo "TODO $n"; continue; }
      aws --endpoint-url "$S3_ENDPOINT" s3 cp "$f" "s3://$S3_BUCKET/$n" --only-show-errors || { echo "FAIL $n"; continue; }
      after=$(s3api head-object --bucket "$S3_BUCKET" --key "$n" --query ContentLength --output text 2>/dev/null || true)
      [ "$after" = "$size" ] && echo "OK $n" || echo "FAIL $n"
    done
  ' | tr -d '\r') || true

echo "$result" | grep -q '^FATAL' && die "Bucket not reachable with the configured endpoint/credentials"
for s in OK TODO MISSING CONFLICT FAIL; do
  echo "$s: $(echo "$result" | grep -c "^$s " || true)"
done
echo "$result" | grep -E '^(MISSING|CONFLICT|FAIL) ' || true

if [ "$APPLY" != 1 ]; then
  echo "Dry-run only. Re-run with --apply to upload and update the database."
  exit 0
fi

ok_list=$(echo "$result" | awk '$1=="OK"{printf "%s'\''%s'\''", (n++?",":""), $2}')
[ -n "$ok_list" ] || die "No verified object, database left untouched"

echo "== Updating dev.file (single transaction, verified objects only)"
psql_pg <<SQL
BEGIN;
UPDATE dev.file
   SET uri = regexp_replace(uri, '^.*/', '')
 WHERE uri LIKE '/%'
   AND regexp_replace(uri, '^.*/', '') = ANY (ARRAY[$ok_list]);
COMMIT;
SQL
remaining=$(psql_pg -c "SELECT count(*) FROM dev.file WHERE uri LIKE '/%'")
echo "Rows still holding a local path (missing/conflict/failed files): $remaining"
echo "Rollback source: $backup"
