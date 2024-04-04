
CREATE USER pgrepl REPLICATION LOGIN ENCRYPTED PASSWORD 'pgreplpassword';
SELECT pg_create_physical_replication_slot('replication_slot1');
SELECT pg_create_physical_replication_slot('replication_slot2');

CREATE TABLE sandbox
(
    sdb_id               serial primary key,
    sdb_short_txt        VARCHAR(40) not null,
    sdb_long_txt         TEXT,
    sdb_creation         TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
