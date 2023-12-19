#! /bin/bash

#--------------------------------------#
# Settings for the node service scripts#
#--------------------------------------#

NODE_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $NODE_SCRIPT_DIR/../../../scripts/srv-dev-env.sh
AVENIRS_LDAP_VOLUMES_ROOT=$VOLUMES_ROOT/apache


NODE_UI_OVERLAY_DIR=$NODE_SCRIPT_DIR/../avenirs-node-overlay/node-ui
NODE_UI_OVERLAY_REALPATH=`realpath $NODE_UI_OVERLAY_DIR`


# Docker env file.
NODE_ENV_FILE=$NODE_SCRIPT_DIR/../.env

# Docker environment.
[ -z "$AVENIRS_NODE_CONTAINER_NAME" ] && AVENIRS_NODE_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}node"
[ -z "$AVENIRS_NODE_UI_CONTAINER_NAME" ] && AVENIRS_NODE_UI_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}node-ui"
[ -z "$AVENIRS_ZOOKEEPER_CONTAINER_NAME" ] && AVENIRS_ZOOKEEPER_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}zookeeper"
[ -z "$AVENIRS_NODE_VOLUMES_ROOT" ] && AVENIRS_NODE_VOLUMES_ROOT=$VOLUMES_ROOT/node
[ -z "$AVENIRS_NODE_DATA_VOLUME" ] && AVENIRS_NODE_DATA_VOLUME=$AVENIRS_NODE_VOLUMES_ROOT/data
[ -z "$AVENIRS_ZOOKEEPER_VOLUMES_ROOT" ] && AVENIRS_ZOOKEEPER_VOLUMES_ROOT=$VOLUMES_ROOT/zookeeper
[ -z "$AVENIRS_ZOOKEEPER_DATA_VOLUME" ] && AVENIRS_ZOOKEEPER_DATA_VOLUME=$AVENIRS_ZOOKEEPER_VOLUMES_ROOT/data
[ -z "$AVENIRS_ZOOKEEPER_LOG_VOLUME" ] && AVENIRS_ZOOKEEPER_LOG_VOLUME=$AVENIRS_ZOOKEEPER_VOLUMES_ROOT/log


# This is required to source this script as the test above can fail.
return 0
