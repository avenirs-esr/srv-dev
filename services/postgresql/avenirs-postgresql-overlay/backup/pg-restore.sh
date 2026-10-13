#!/bin/bash
# Restore helper, run in a one-off container with the server stopped (see services/postgresql/README-backup.md).
# Usage: pg-restore.sh                       -> latest state
#        pg-restore.sh "2026-10-12 23:59:00" -> PITR to this time (server timezone)
set -e
if [ -n "$1" ]; then
    gosu postgres pgbackrest --stanza=avenirs --delta --type=time --target="$1" --target-action=promote restore
else
    gosu postgres pgbackrest --stanza=avenirs --delta restore
fi
