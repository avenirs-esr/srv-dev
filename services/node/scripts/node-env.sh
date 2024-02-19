#! /bin/bash

#--------------------------------------#
# Settings for the node service scripts#
#--------------------------------------#

NODE_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $NODE_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file.
NODE_ENV_FILE=$NODE_SCRIPT_DIR/../.env

# Root of the node api project and build dir.
NODE_API_ROOT=$NODE_SCRIPT_DIR/../node-api
NODE_API_BUILD_DIR=$NODE_API_ROOT/dist

# Docker environment.
[ -z "$AVENIRS_NODE_CONTAINER_NAME" ] && AVENIRS_NODE_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}node"
[ -z "$AVENIRS_NODE_CONTAINER_PORT" ] && AVENIRS_NODE_CONTAINER_PORT=8030
[ -z "$AVENIRS_WS_CONTAINER_PORT" ] && AVENIRS_WS_CONTAINER_PORT=8031

# This is required to source this script as the test above can fail.
return 0
