#!/bin/bash
# Healthcheck: fails on archiving errors, backup older than MAX_BACKUP_AGE_H hours, or repo disk > 85%.
MAX_BACKUP_AGE_H=${MAX_BACKUP_AGE_H:-36}
PSQL="psql -h /var/run/postgresql -U $POSTGRES_USER -d postgres -Atc"

pg_isready -q -h /var/run/postgresql -U "$POSTGRES_USER" || exit 1

[ "$($PSQL "select coalesce(last_failed_time > coalesce(last_archived_time,'-infinity'), false) from pg_stat_archiver")" = "f" ] \
    || { echo "WAL archiving failing"; exit 1; }

last=$(pgbackrest --stanza=avenirs info --output=json | sed -n 's/.*"stop":\([0-9]*\).*/\1/p' | sort -n | tail -1)
if [ -n "$last" ]; then
    [ $(( $(date +%s) - last )) -lt $(( MAX_BACKUP_AGE_H * 3600 )) ] || { echo "last backup too old"; exit 1; }
fi

[ "$(df --output=pcent /var/lib/pgbackrest | tail -1 | tr -dc 0-9)" -lt 85 ] || { echo "backup repo disk > 85%"; exit 1; }
