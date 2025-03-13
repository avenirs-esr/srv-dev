CREATE USER pgrepl REPLICATION LOGIN ENCRYPTED PASSWORD 'pgreplpassword';

SELECT pg_create_physical_replication_slot('replication_slot1');
SELECT pg_create_physical_replication_slot('replication_slot2');
