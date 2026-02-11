#! /bin/bash

#---------------------------------------------#
# Settings for the Opensearch service scripts #
#---------------------------------------------#

OPENSEARCH_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $OPENSEARCH_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file.
OPENSEARCH_ENV_FILE=$OPENSEARCH_SCRIPT_DIR/../.env

# Docker environment.
[ -z "$AVENIRS_OPENSEARCH_CONTAINER_NAME" ] && AVENIRS_OPENSEARCH_CONTAINER_NAME="${AVENIRS_PORTFOLIO_CONTAINER_PREFIX}opensearch"
[ -z "$AVENIRS_OPENSEARCH_DASHBOARDS_CONTAINER_NAME" ] && AVENIRS_OPENSEARCH_DASHBOARDS_CONTAINER_NAME="${AVENIRS_PORTFOLIO_CONTAINER_PREFIX}opensearch-dashboards"

# This is required to source this script as the test above can fail.
return 0
