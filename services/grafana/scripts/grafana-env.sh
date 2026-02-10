#! /bin/bash

#------------------------------------------#
# Settings for the Grafana service scripts #
#------------------------------------------#

GRAFANA_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $GRAFANA_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file.
GRAFANA_ENV_FILE=$GRAFANA_SCRIPT_DIR/../.env

# Docker environment.
[ -z "$AVENIRS_GRAFANA_CONTAINER_NAME" ] && AVENIRS_GRAFANA_CONTAINER_NAME="${AVENIRS_PORTFOLIO_CONTAINER_PREFIX}grafana"
[ -z  "$GF_SECURITY_ADMIN_USER" ] && GF_SECURITY_ADMIN_USER=gfuser
[ -z  "$GF_SECURITY_ADMIN_PASSWORD" ] && GF_SECURITY_ADMIN_PASSWORD=gfpassword

# This is required to source this script as the test above can fail.
return 0
