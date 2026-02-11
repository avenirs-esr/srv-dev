#! /bin/bash

#---------------------------------------------#
# Settings for the Prometheus service scripts #
#---------------------------------------------#

PROMETHEUS_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $PROMETHEUS_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file.
PROMETHEUS_ENV_FILE=$PROMETHEUS_SCRIPT_DIR/../.env

# Docker environment.
[ -z "$AVENIRS_PROMETHEUS_CONTAINER_NAME" ] && AVENIRS_PROMETHEUS_CONTAINER_NAME="${AVENIRS_PORTFOLIO_CONTAINER_PREFIX}prometheus"

# This is required to source this script as the test above can fail.
return 0
