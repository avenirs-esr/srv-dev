# PostgreSQL backup / restore (pgBackRest)

## How it works

| What | Details |
|---|---|
| WAL archiving | Continuous, through `archive_command` (`pgbackrest archive-push`), at least every 15 min (`archive_timeout`) |
| Backups | Physical, every day at 02:00 **UTC** (04:00 Paris in summer): *full* on Sunday, *diff* the other days (`BACKUP_HOUR`, `BACKUP_FULL_DAY`) |
| Retention | Rolling 7 days (`repo1-retention-full`); the WAL needed by these backups is kept, everything else is expired automatically |
| Restore | To any point in time (PITR) between the oldest backup and the last archived WAL |
| Repository | Docker volume `postgres_primary_backup` (`/var/lib/pgbackrest`) |
| Replication slots | `max_slot_wal_keep_size = 5GB`: an inactive slot can no longer fill the disk |
| Monitoring | Docker healthcheck: `unhealthy` on archiving failure, last backup older than 36 h, or repository disk above 85 % |

Files: `avenirs-postgresql-overlay/backup/` (image, `pgbackrest.conf`, scheduler, healthcheck, restore helper).

## npm commands

| Command | Purpose |
|---|---|
| `npm run pg:backup:info` | List backups and the archived WAL range (`status: ok` expected) |
| `npm run pg:backup:now` | Immediate full backup (silent when OK) |
| `npm run pg:backup:check` | Run the healthcheck by hand (no output = OK) |
| `npm run pg:wal:checkpoint` | Force a checkpoint: recycles already archived WAL |
| `npm run pg:slots` | List replication slots (`active`, `wal_status`) |
| `npm run pg:restore:stop` | Stop PostgreSQL before a restore |
| `npm run pg:restore [-- "<time>"]` | Restore (latest state, or to the given time) |
| `npm run pg:restore:start` | Start PostgreSQL again after a restore |

## Restore

```
npm run pg:restore:stop
npm run pg:restore -- "2026-10-13 14:15:00+02"    # no argument: latest archived state
npm run pg:restore:start
```

- Always give the time **with its UTC offset** (`+02` summer, `+01` winter). Logs are in UTC.
- A restore **overwrites the current database**: anything after the chosen time is lost. Stop the applications before, start them after.
- The time must be after the oldest backup and before the last archived WAL (`pg:backup:info`). To target "now", force the archiving first:
  `docker compose exec postgresql-primary sh -c 'psql -U "$POSTGRES_USER" -d postgres -c "SELECT pg_switch_wal()"'`

### Check after a restore

```
docker logs --tail 60 avenirs-pgsql-primary 2>&1 | grep -Ei 'recovery|timeline|ready to accept|fatal'
npm run pg:backup:now        # new full backup on the new timeline
npm run pg:backup:info       # status: ok, 2 backups
```

Expected: `recovery stopping before commit…`, `selected new timeline ID`, `ready to accept connections`. A restore creates a new *timeline*: this is normal.

## Check that everything is fine (routine)

```
npm run pg:backup:info                                  # recent backup, status: ok
npm run pg:backup:check                                 # healthcheck
docker exec avenirs-pgsql-primary du -sh /var/lib/postgresql/data/pg_wal   # < ~1 GB
docker compose exec postgresql-primary sh -c 'psql -U "$POSTGRES_USER" -d postgres -c "SELECT failed_count, last_archived_time, last_failed_time FROM pg_stat_archiver"'
```

`failed_count` must not increase. The scheduler only writes to `/var/log/pgbackrest/scheduler.log` on errors or when a backup runs.

## Deploy on an environment (DEV, QUALIF, RECETTE, PREPROD)

```
npm run deploy                   # builds the image, creates the repository, the stanza and the first backup
npm run pg:backup:info           # check status: ok
```

Existing environment with accumulated WAL, additionally:

```
npm run pg:wal:checkpoint        # recycle archived WAL
npm run pg:slots                 # inactive / lost slots?
docker compose exec postgresql-primary sh -c 'psql -U "$POSTGRES_USER" -d postgres -c "SELECT pg_drop_replication_slot($$<slot>$$)"'   # if unused
docker volume rm srv-dev_postgres_primary_archive      # old archive volume
```

## Troubleshooting

| Symptom | Cause / action |
|---|---|
| `must not be run as the root user` | Run pgBackRest with `-u postgres` (already done in the npm scripts) |
| `role "postgres" does not exist` | The superuser is `POSTGRES_USER` (`PGBACKREST_PG1_USER` in the compose file) |
| Container `unhealthy` | `npm run pg:backup:check` and `pg_stat_archiver` show the cause |
| `unable to acquire lock … archive` | Async archiving is draining a backlog: wait a few minutes |
| `recovery ended before configured recovery target` | Target time is after the last archived WAL: run `pg_switch_wal()` and retry |
