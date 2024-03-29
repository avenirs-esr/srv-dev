#! /bin/bash

#--------------------------------------#
# Settings for the Kafka scripts       #
#--------------------------------------#

KAFKA_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $KAFKA_SCRIPT_DIR/../../../scripts/srv-dev-env.sh


KAFKA_UI_OVERLAY_DIR=$KAFKA_SCRIPT_DIR/../avenirs-kafka-overlay/kafka-ui
KAFKA_UI_OVERLAY_REALPATH=`realpath $KAFKA_UI_OVERLAY_DIR`


# Docker env file.
KAFKA_ENV_FILE=$KAFKA_SCRIPT_DIR/../.env

# Docker environment.
[ -z "$AVENIRS_KAFKA_CONTAINER_NAME" ] && AVENIRS_KAFKA_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}kafka"
[ -z "$AVENIRS_KAFKA_UI_CONTAINER_NAME" ] && AVENIRS_KAFKA_UI_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}kafka-ui"
[ -z "$AVENIRS_ZOOKEEPER_CONTAINER_NAME" ] && AVENIRS_ZOOKEEPER_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}zookeeper"
[ -z "$AVENIRS_KAFKA_VOLUMES_ROOT" ] && AVENIRS_KAFKA_VOLUMES_ROOT=$VOLUMES_ROOT/kafka
[ -z "$AVENIRS_KAFKA_DATA_VOLUME" ] && AVENIRS_KAFKA_DATA_VOLUME=$AVENIRS_KAFKA_VOLUMES_ROOT/data
[ -z "$AVENIRS_ZOOKEEPER_VOLUMES_ROOT" ] && AVENIRS_ZOOKEEPER_VOLUMES_ROOT=$VOLUMES_ROOT/zookeeper
[ -z "$AVENIRS_ZOOKEEPER_DATA_VOLUME" ] && AVENIRS_ZOOKEEPER_DATA_VOLUME=$AVENIRS_ZOOKEEPER_VOLUMES_ROOT/data
[ -z "$AVENIRS_ZOOKEEPER_LOG_VOLUME" ] && AVENIRS_ZOOKEEPER_LOG_VOLUME=$AVENIRS_ZOOKEEPER_VOLUMES_ROOT/log


# This is required to source this script as the test above can fail.
return 0
