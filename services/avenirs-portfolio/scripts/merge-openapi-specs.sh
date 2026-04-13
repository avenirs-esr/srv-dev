#!/bin/sh
set -euo pipefail

SPECS_DIR="${API_SPECS_DIR:-/usr/local/apache2/htdocs/api-specs}"
MERGED_FILE_NAME="openapi-merged.json"
MERGE_CONFIG_PATH="$SPECS_DIR/openapi-merge.config.json"
SWAGGER_URLS="http://avenirs-portfolio-api:10000/avenirs-portfolio-api/api-docs http://avenirs-portfolio-back-office:10010/avenirs-portfolio-back-office/api-docs http://avenirs-portfolio-interoperability:10020/avenirs-portfolio-interoperability/api-docs"

wait_for_endpoint() {
  url="$1"
  timeout="${2:-300}"
  interval="${3:-5}"
  elapsed=0
  echo "Waiting for endpoint $url to be available..."
  while [ "$elapsed" -lt "$timeout" ]; do
    if curl -s --head --fail "$url" >/dev/null 2>&1; then
      echo "Endpoint $url is available!"
      return 0
    fi
    echo "Endpoint $url not available yet. Retrying in $interval seconds..."
    sleep "$interval"
    elapsed=$((elapsed + interval))
  done
  echo "Timeout reached. Endpoint $url is not available after $timeout seconds."
  return 1
}

filter_openapi_paths() {
  file="$1"
  tmp="$(mktemp)"

  jq '
    .paths |= with_entries(
      select(
        (.key | startswith("/health") | not) and
        (.key | startswith("/actuator") | not)
      )
    )
  ' "$file" > "$tmp"

  mv "$tmp" "$file"
}

mkdir -p "$SPECS_DIR"

for u in $SWAGGER_URLS; do
  wait_for_endpoint "$u" 300 5
  case "$u" in
    *avenirs-portfolio-api*) out="$SPECS_DIR/portfolio.json" ;;
    *avenirs-portfolio-back-office*) out="$SPECS_DIR/back-office.json" ;;
    *avenirs-portfolio-interoperability*) out="$SPECS_DIR/interoperability.json" ;;
    *) echo "Unknown swagger url $u" >&2; exit 1 ;;
  esac

  echo "Fetching $u -> $out"
  curl -s "$u" -o "$out"
  echo "Fetched: $out"

  echo "Filtering technical endpoints from $out"
  filter_openapi_paths "$out"
done

echo "Writing merge config: $MERGE_CONFIG_PATH"
cat >"$MERGE_CONFIG_PATH" <<EOF
{
  "output": "$MERGED_FILE_NAME",
  "inputs": [
    { "inputFile": "portfolio.json" },
    { "inputFile": "back-office.json" },
    { "inputFile": "interoperability.json" }
  ]
}
EOF

echo "Merging OpenAPI specs -> $SPECS_DIR/$MERGED_FILE_NAME"
npx openapi-merge-cli --config "$MERGE_CONFIG_PATH"

echo "Done. Merged spec at: $SPECS_DIR/$MERGED_FILE_NAME"
