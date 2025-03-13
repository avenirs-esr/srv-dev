
CREATE USER debezium WITH PASSWORD 'p@@ss4DBZCDC' LOGIN REPLICATION;

CREATE DATABASE realtime_db;

-- Accorder tous les privilèges nécessaires à l'utilisateur debezium
ALTER DATABASE realtime_db OWNER TO debezium;
\c realtime_db

-- Accorder des privilèges à l'utilisateur debezium
GRANT ALL PRIVILEGES ON DATABASE realtime_db TO debezium;
GRANT USAGE ON SCHEMA public TO debezium;
GRANT ALL PRIVILEGES ON SCHEMA public TO debezium;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO debezium;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO debezium;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO debezium;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO debezium;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO debezium;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON FUNCTIONS TO debezium;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TYPES TO debezium;


CREATE TABLE public.sample (
    sdb_id SERIAL PRIMARY KEY,
    sdb_short_txt VARCHAR(40) NOT NULL,
    sdb_long_txt TEXT,
    sdb_creation TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE SUBSCRIPTION cdc_sub
CONNECTION 'host=avenirs-pgsql-primary dbname=realtime_db user=pgrepl password=pgreplpassword'
PUBLICATION cdc_pub
WITH (copy_data = true);

CREATE PUBLICATION realtime_pub FOR ALL TABLES;

GRANT PUBLICATION realtime_pub TO debezium;
