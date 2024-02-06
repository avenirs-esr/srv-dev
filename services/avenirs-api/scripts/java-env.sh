#! /bin/bash

#--------------------------------------#
# Settings for the node service scripts#
#--------------------------------------#

AVENIRS_APISCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $AVENIRS_API_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file.
AVENIRS_API_ENV_FILE=$AVENIRS_API_SCRIPT_DIR/../.env

# Root of the node api project and build dir.
AVENIRS_API_API_ROOT=$AVENIRS_API_SCRIPT_DIR/../avenirs-api

# Docker environment.
[ -z "$AVENIRS_AVENIRS_API_CONTAINER_NAME" ] && AVENIRS_AVENIRS_API_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}api"
[ -z "$AVENIRS_AVENIRS_API_CONTAINER_PORT" ] && AVENIRS_AVENIRS_API_CONTAINER_PORT=10000

# This is required to source this script as the test above can fail.
return 0
