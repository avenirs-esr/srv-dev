#! /bin/bash

#--------------------------------------#
# Settings for the realtime-worker     # 
# service scripts                      #
#--------------------------------------#

REALTIME_WORKER_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $REALTIME_WORKER_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file.
REALTIME_WORKER_ENV_FILE=$REALTIME_WORKER_SCRIPT_DIR/../.env

# Root of the realtime-worker project and build dir.
REALTIME_WORKER_ROOT=$REALTIME_WORKER_SCRIPT_DIR/../avenirs-portfolio-realtime-worker
REALTIME_WORKER_BUILD_DIR=$REALTIME_WORKER_ROOT/dist

# Docker environment.
[ -z "$AVENIRS_NODE_CONTAINER_NAME" ] && AVENIRS_NODE_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}node"
[ -z "$AVENIRS_NODE_CONTAINER_PORT" ] && AVENIRS_NODE_CONTAINER_PORT=8030
[ -z "$AVENIRS_WS_CONTAINER_PORT" ] && AVENIRS_WS_CONTAINER_PORT=8031

# This is required to source this script as the test above can fail.
return 0
