#!/bin/bash
# Daily physical backup: full on BACKUP_FULL_DAY (default Sunday), differential otherwise.
STANZA=avenirs
BACKUP_HOUR=${BACKUP_HOUR:-02}
BACKUP_FULL_DAY=${BACKUP_FULL_DAY:-7}

log() { echo "$(date -Is) [scheduler] $*"; }

until pg_isready -q -h /var/run/postgresql -U "$POSTGRES_USER"; do sleep 5; done

# stanza-create needs the archive lock, held by the async archive-push while it drains a backlog.
if ! pgbackrest --stanza=$STANZA info 2>/dev/null | grep -q "stanza: $STANZA"; then
    until pgbackrest --stanza=$STANZA stanza-create; do log "stanza-create failed, retrying"; sleep 30; done
fi
pgbackrest --stanza=$STANZA check || log "check failed"

# Initial full backup so that PITR is possible right away.
if ! pgbackrest --stanza=$STANZA info --output=json | grep -q '"backup":\[{'; then
    log "no backup found, running initial full backup"
    pgbackrest --stanza=$STANZA --type=full backup || log "initial backup failed"
fi

last_day=""
while true; do
    today=$(date +%F)
    if [ "$(date +%H)" = "$BACKUP_HOUR" ] && [ "$today" != "$last_day" ]; then
        if [ "$(date +%u)" = "$BACKUP_FULL_DAY" ]; then type=full; else type=diff; fi
        log "running $type backup"
        pgbackrest --stanza=$STANZA --type=$type backup && pgbackrest --stanza=$STANZA expire \
            && last_day=$today || log "$type backup failed"
        psql -h /var/run/postgresql -U "$POSTGRES_USER" -d postgres -Atc \
            "select 'inactive replication slot: '||slot_name||' wal_status='||wal_status from pg_replication_slots where not active" \
            | while read -r l; do log "$l"; done
    fi
    sleep 300
done
