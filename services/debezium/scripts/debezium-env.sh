#! /bin/bash

#--------------------------------------#
# Settings for the Debezium scripts    #
#--------------------------------------#
DEBEZIUM_SCRIPT_DIR=$1

. $DEBEZIUM_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

. $DEBEZIUM_SCRIPT_DIR/../../postgresql/scripts/postgresql-env.sh

DEBEZIUM_OVERLAY_DIR=$DEBEZIUM_SCRIPT_DIR/../avenirs-debezium-overlay
# Container name
[ -z  "$AVENIRS_DEBEZIUM_CONTAINER_NAME" ] && AVENIRS_DEBEZIUM_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}debezium"


DEBEZIUM_ENV_FILE=$DEBEZIUM_SCRIPT_DIR/../.env