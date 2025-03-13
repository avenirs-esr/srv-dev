
SELECT pg_create_logical_replication_slot('debezium_slot', 'pgoutput');

SELECT * FROM pg_publication;