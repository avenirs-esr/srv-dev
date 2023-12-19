#! /bin/bash

#--------------------------------------#
# Settings for the node service scripts#
#--------------------------------------#

NODE_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $NODE_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file.
NODE_ENV_FILE=$NODE_SCRIPT_DIR/../.env

# Docker environment.
[ -z "$AVENIRS_NODE_CONTAINER_NAME" ] && AVENIRS_NODE_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}node"

# This is required to source this script as the test above can fail.
return 0
