#!/bin/sh

echo "============================="
echo "Waiting for PostgreSQL primary ${AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME} to be ready..."
until docker exec ${AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME} pg_isready -U ${POSTGRES_USER:-postgres}; do
  sleep 2
done
echo "PostgreSQL primary is ready, initializing database..."
cat /scripts/init_cdc_primary.sql | docker exec -i ${AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME} psql -U ${POSTGRES_USER:-postgres} template1
echo "Primary database initialization completed."

echo "Waiting for PostgreSQL secondary1 ${AVENIRS_POSTGRESQL_SECONDARY1_CONTAINER_NAME} to be ready..."
until docker exec ${AVENIRS_POSTGRESQL_SECONDARY1_CONTAINER_NAME} pg_isready -U ${POSTGRES_USER:-postgres}; do
  sleep 2
done

echo "Waiting for PostgreSQL secondary2 ${AVENIRS_POSTGRESQL_SECONDARY2_CONTAINER_NAME} to be ready..."
until docker exec ${AVENIRS_POSTGRESQL_SECONDARY2_CONTAINER_NAME} pg_isready -U ${POSTGRES_USER:-postgres}; do
  sleep 2
done

echo "Waiting for realtime_db to be replicated to secondary 1 ..."
until docker exec ${AVENIRS_POSTGRESQL_SECONDARY1_CONTAINER_NAME} psql -U ${POSTGRES_USER:-postgres} template1 -c "SELECT 1 FROM pg_database WHERE datname='realtime_db'" 2>/dev/null | grep -q 1; do
  echo "Database realtime_db not yet replicated, waiting..."
  sleep 5
done


echo "Waiting for realtime_db to be replicated to secondary 2 ..."
until docker exec ${AVENIRS_POSTGRESQL_SECONDARY2_CONTAINER_NAME} psql -U ${POSTGRES_USER:-postgres} template1 -c "SELECT 1 FROM pg_database WHERE datname='realtime_db'" 2>/dev/null | grep -q 1; do
  echo "Database realtime_db not yet replicated, waiting..."
  sleep 5
done

echo "PostgreSQL secondary is ready, setting up CDC..."
cat /scripts/init_cdc_secondary.sql | docker exec -i ${AVENIRS_POSTGRESQL_SECONDARY1_CONTAINER_NAME} psql -U ${POSTGRES_USER:-postgres}  -d realtime_db
cat /scripts/init_cdc_secondary.sql | docker exec -i ${AVENIRS_POSTGRESQL_SECONDARY2_CONTAINER_NAME} psql -U ${POSTGRES_USER:-postgres}  -d realtime_db
echo "Secondary database CDC setup completed."
