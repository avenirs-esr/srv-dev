ARG POSTGRES_VERSION
FROM postgres:${POSTGRES_VERSION}

RUN apt-get update \
    && apt-get install -y --no-install-recommends pgbackrest \
    && rm -rf /var/lib/apt/lists/*

COPY pgbackrest.conf /etc/pgbackrest/pgbackrest.conf
COPY entrypoint-backup.sh pg-backup-scheduler.sh pg-backup-check.sh pg-restore.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/entrypoint-backup.sh /usr/local/bin/pg-backup-scheduler.sh \
        /usr/local/bin/pg-backup-check.sh /usr/local/bin/pg-restore.sh \
    && sed -i 's/\r$//' /usr/local/bin/*.sh /etc/pgbackrest/pgbackrest.conf \
    && mkdir -p /var/lib/pgbackrest /var/log/pgbackrest \
    && chown postgres:postgres /var/lib/pgbackrest /var/log/pgbackrest

ENTRYPOINT ["entrypoint-backup.sh"]
CMD ["postgres"]
