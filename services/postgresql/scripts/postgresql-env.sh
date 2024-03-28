#! /bin/bash

#--------------------------------------#
# Settings for the Postgresql scripts  #
#--------------------------------------#

POSTGRESQL_SCRIPT_DIR=$1
. $POSTGRESQL_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file
POSTGRESQL_ENV_FILE=$POSTGRESQL_SCRIPT_DIR/../.env


# Docker environment 
[ -z  "$AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME" ] && AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}pgsql-primary"
[ -z  "$AVENIRS_POSTGRESQL_SECONDARY1_CONTAINER_NAME" ] && AVENIRS_POSTGRESQL_SECONDARY1_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}pgsql-secondary1"
[ -z  "$AVENIRS_POSTGRESQL_SECONDARY2_CONTAINER_NAME" ] && AVENIRS_POSTGRESQL_SECONDARY2_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}pgsql-secondary2"

[ -z  "$POSTGRES_PASSWORD" ] && POSTGRES_USER=pguser
[ -z  "$POSTGRES_PASSWORD" ] && POSTGRES_PASSWORD=pgpassword
[ -z  "$POSTGRES_DB" ] && POSTGRES_DB=avenirs_eportfolio


# This is required to source this script as the test above can fail.
return 0
