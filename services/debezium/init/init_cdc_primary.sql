CREATE USER debezium WITH PASSWORD 'p@@ss4DBZCDC' LOGIN REPLICATION;

CREATE DATABASE realtime_db;

\c realtime_db

CREATE TABLE public.sample (
    sdb_id               SERIAL PRIMARY KEY,
    sdb_short_txt        VARCHAR(40) NOT NULL,
    sdb_long_txt         TEXT,
    sdb_creation         TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

GRANT CONNECT ON DATABASE realtime_db TO debezium;
GRANT USAGE ON SCHEMA public TO debezium;
GRANT SELECT ON public.sample TO debezium;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO debezium;

CREATE PUBLICATION realtime_pub FOR TABLE public.sample;