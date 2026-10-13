#!/bin/bash
# Runs as root: fixes the repository ownership (the cause of the archive failures),
# starts the backup scheduler as postgres, then hands over to the official entrypoint.
set -e

if [ "$1" = "postgres" ] && [ "$(id -u)" = "0" ]; then
    mkdir -p /var/lib/pgbackrest/spool /var/log/pgbackrest
    chown -R postgres:postgres /var/lib/pgbackrest /var/log/pgbackrest
    gosu postgres pg-backup-scheduler.sh >> /var/log/pgbackrest/scheduler.log 2>&1 &
fi

exec docker-entrypoint.sh "$@"
