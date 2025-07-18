#! /bin/bash

#---------------------------------------------#
# Settings for the Avenirs portffolio scripts #
#---------------------------------------------#
AVENIRS_PORTFOLIO_SCRIPT_DIR=$1

# Global settings file. The settings loaded from this file are not overridden.
. $AVENIRS_PORTFOLIO_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file
AVENIRS_PORTFOLIO_ENV_FILE=$AVENIRS_PORTFOLIO_SCRIPT_DIR/../.env

# Docker settings. Can be overridden in srv-dev.env.sh
[ -z "$AVENIRS_PORTFOLIO_CONTAINER_PREFIX" ] && AVENIRS_PORTFOLIO_CONTAINER_PREFIX="${AVENIRS_CONTAINER_PREFIX}portfolio-"
[ -z "$AVENIRS_PROMETHEUS_CONTAINER_NAME" ] && AVENIRS_PROMETHEUS_CONTAINER_NAME="${AVENIRS_PORTFOLIO_CONTAINER_PREFIX}prometheus"
[ -z "$AVENIRS_GRAFANA_CONTAINER_NAME" ] && AVENIRS_GRAFANA_CONTAINER_NAME="${AVENIRS_PORTFOLIO_CONTAINER_PREFIX}grafana"
[ -z  "$GF_SECURITY_ADMIN_USER" ] && GF_SECURITY_ADMIN_USER=gfuser
[ -z  "$GF_SECURITY_ADMIN_PASSWORD" ] && GF_SECURITY_ADMIN_PASSWORD=gfpassword

AVENIRS_PORTFOLIO_BACKEND_URL="http://localhost/apim/"
if [ -f "$AVENIRS_PORTFOLIO_SCRIPT_DIR/../../../backend-url.generated.env" ]; then
   . "$AVENIRS_PORTFOLIO_SCRIPT_DIR/../../../backend-url.generated.env"
fi


# Import required to generate the initialization database scripts in the Postgres container entry point.
. $AVENIRS_PORTFOLIO_SCRIPT_DIR/../../postgresql/scripts/postgresql-env.sh $AVENIRS_PORTFOLIO_SCRIPT_DIR/../../postgresql/scripts/ 2> /dev/null \
    || err "Unable to source . $AVENIRS_PORTFOLIO_SCRIPT_DIR/../../postgresql/scripts/postgresql-env.sh from $AVENIRS_PORTFOLIO_SCRIPT_DIR"


# Overlay root
[ -z  "$AVENIRS_PORTFOLIO_OVERLAY_DIR" ] && AVENIRS_PORTFOLIO_OVERLAY_DIR=$AVENIRS_PORTFOLIO_SCRIPT_DIR/../avenirs-portfolio-overlay/
AVENIRS_PORTFOLIO_OVERLAY_BASENAME=`basename $AVENIRS_PORTFOLIO_OVERLAY_DIR`

# ---- avenirs-portfolio-api
AVENIRS_PORTFOLIO_API_REPOSITORY_DIR=$AVENIRS_PORTFOLIO_SCRIPT_DIR/../avenirs-portfolio-api

[ -z  "$AVENIRS_PORTFOLIO_API_OVERLAY_DIR" ] && AVENIRS_PORTFOLIO_API_OVERLAY_DIR=$AVENIRS_PORTFOLIO_OVERLAY_DIR/avenirs-portfolio-api/
AVENIRS_PORTFOLIO_API_OVERLAY_BASENAME=$AVENIRS_PORTFOLIO_OVERLAY_BASENAME/`basename $AVENIRS_PORTFOLIO_API_OVERLAY_DIR`

[ -z "$AVENIRS_PORTFOLIO_API_CONTAINER_NAME" ] && AVENIRS_PORTFOLIO_API_CONTAINER_NAME="${AVENIRS_PORTFOLIO_CONTAINER_PREFIX}api"

[ -z  "$AVENIRS_PORTFOLIO_API_VERSION" ] && AVENIRS_PORTFOLIO_API_VERSION="0.0.1"

AVENIRS_PORTFOLIO_API_REMOTE_BRANCH=remotes/origin/main

AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE=$AVENIRS_PORTFOLIO_API_OVERLAY_DIR/src/main/resources/env.properties

# ---- avenirs-cofolio-client
[ -z "$AVENIRS_COFOLIO_CLIENT_CONTAINER_NAME" ] && AVENIRS_COFOLIO_CLIENT_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}cofolio-client"

AVENIRS_COFOLIO_CLIENT_REPOSITORY_DIR=$AVENIRS_PORTFOLIO_SCRIPT_DIR/../avenirs-cofolio-client

[ -z  "$AVENIRS_COFOLIO_CLIENT_OVERLAY_DIR" ] && AVENIRS_COFOLIO_CLIENT_OVERLAY_DIR=$AVENIRS_PORTFOLIO_OVERLAY_DIR/avenirs-cofolio-client/

AVENIRS_COFOLIO_CLIENT_OVERLAY_BASENAME=$AVENIRS_PORTFOLIO_OVERLAY_BASENAME/`basename $AVENIRS_COFOLIO_CLIENT_OVERLAY_DIR`
AVENIRS_COFOLIO_CLIENT_ENV_FILE=$AVENIRS_COFOLIO_CLIENT_OVERLAY_DIR/.env

# ---- avenirs-portfolio-security
AVENIRS_PORTFOLIO_SECURITY_REPOSITORY_DIR=$AVENIRS_PORTFOLIO_SCRIPT_DIR/../avenirs-portfolio-security

[ -z "$AVENIRS_PORTFOLIO_SECURITY_CONTAINER_NAME" ] && AVENIRS_PORTFOLIO_SECURITY_CONTAINER_NAME="${AVENIRS_PORTFOLIO_CONTAINER_PREFIX}security"


[ -z  "$AVENIRS_PORTFOLIO_SECURITY_OVERLAY_DIR" ] && AVENIRS_PORTFOLIO_SECURITY_OVERLAY_DIR=$AVENIRS_PORTFOLIO_OVERLAY_DIR/avenirs-portfolio-security/
AVENIRS_PORTFOLIO_SECURITY_OVERLAY_BASENAME=$AVENIRS_PORTFOLIO_OVERLAY_BASENAME/`basename $AVENIRS_PORTFOLIO_SECURITY_OVERLAY_DIR`

[ -z  "$AVENIRS_PORTFOLIO_SECURITY_VERSION" ] && AVENIRS_PORTFOLIO_SECURITY_VERSION="0.0.1"

AVENIRS_PORTFOLIO_SECURITY_REMOTE_BRANCH=remotes/origin/main
AVENIRS_PORTFOLIO_SECURITY_LOCAL_BRANCH=local_main
AVENIRS_PORTFOLIO_SECURITY_MAIN_BRANCH="main"

AVENIRS_PORTFOLIO_SECURITY_SPRING_ENV_FILE=$AVENIRS_PORTFOLIO_SECURITY_OVERLAY_DIR/src/main/resources/env.properties

# Database initialization
PGSQL_INIT_DIR=$POSTGRESQL_OVERLAY_DIR/init
JASYPT_UTIL_SCRIPT=$AVENIRS_PORTFOLIO_SCRIPT_DIR/../../../scripts/jasypt/jasypt-decrypt.sh
AVENIRS_PORTFOLIO_SECURITY_CLEAN_DB=$AVENIRS_PORTFOLIO_SCRIPT_DIR/../avenirs-portfolio-security/src/main/resources/db/clean.sql
AVENIRS_PORTFOLIO_SECURITY_CLEAN_DB_CLEAR=$PGSQL_INIT_DIR/10_avenirs-security_clean.generated.sql

AVENIRS_PORTFOLIO_SECURITY_INIT_DB=$AVENIRS_PORTFOLIO_SCRIPT_DIR/../avenirs-portfolio-security/src/main/resources/db/init-db.sql
AVENIRS_PORTFOLIO_SECURITY_INIT_DB_CLEAR=$PGSQL_INIT_DIR/11_avenirs-security_init-db.generated.sql

AVENIRS_PORTFOLIO_SECURITY_CLEAN_TEST_DB=$AVENIRS_PORTFOLIO_SCRIPT_DIR/../avenirs-portfolio-security/src/test/resources/db/clean-test-db.sql
AVENIRS_PORTFOLIO_SECURITY_CLEAN_TEST_DB_CLEAR=$PGSQL_INIT_DIR/12_avenirs-security_clean-test-db.generated.sql

AVENIRS_PORTFOLIO_SECURITY_INIT_TEST_DB=$AVENIRS_PORTFOLIO_SCRIPT_DIR/../avenirs-portfolio-security/src/test/resources/db/init-test-db.sql
AVENIRS_PORTFOLIO_SECURITY_INIT_TEST_DB_CLEAR=$PGSQL_INIT_DIR/13_avenirs-security_init-test-db.generated.sql

AVENIRS_PORTFOLIO_API_CLEAN_DB=$AVENIRS_PORTFOLIO_SCRIPT_DIR/../avenirs-portfolio-api/src/main/resources/db/clean.sql
AVENIRS_PORTFOLIO_API_CLEAN_DB_CLEAR=$PGSQL_INIT_DIR/10_avenirs-api_clean.generated.sql

AVENIRS_PORTFOLIO_API_INIT_DB=$AVENIRS_PORTFOLIO_SCRIPT_DIR/../avenirs-portfolio-api/src/main/resources/db/init-db.sql
AVENIRS_PORTFOLIO_API_INIT_DB_CLEAR=$PGSQL_INIT_DIR/11_avenirs-api_init-db.generated.sql

