
CREATE USER pgrepl REPLICATION LOGIN ENCRYPTED PASSWORD 'pgreplpassword';


CREATE TABLE sandbox
(
    sdb_id               serial primary key,
    sdb_short_txt        VARCHAR(40) not null,
    sdb_long_txt         TEXT,
    sdb_creation         TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
