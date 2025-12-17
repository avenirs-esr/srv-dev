#! /bin/bash

#--------------------------------------#
# Kafka bootstrap                     #
#                                      #  
# - Docker volumes                     #
# - Docker .env file to set            #
#   environment from settings.         #
#--------------------------------------#

KAFKA_SCRIPT_DIR=`dirname $0`


# Initialization
. $KAFKA_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
info "Kafka bootstrapping started."
. $KAFKA_SCRIPT_DIR/kafka-env.sh $KAFKA_SCRIPT_DIR || err "Unable to source $PWD/$KAFKA_SCRIPT_DIR/kafka-env.sh"

# Network check
check_network

# .env file generation
echo "AVENIRS_KAFKA_CONTAINER_NAME=$AVENIRS_KAFKA_CONTAINER_NAME" > $KAFKA_ENV_FILE
echo "AVENIRS_KAFKA_VOLUMES_ROOT=$AVENIRS_KAFKA_VOLUMES_ROOT" >> $KAFKA_ENV_FILE
echo "AVENIRS_KAFKA_UI_CONTAINER_NAME=$AVENIRS_KAFKA_UI_CONTAINER_NAME" >> $KAFKA_ENV_FILE
echo "KAFKA_UI_OVERLAY_DIR=$KAFKA_UI_OVERLAY_DIR" >> $KAFKA_ENV_FILE
echo "KAFKA_UI_OVERLAY_REALPATH=$KAFKA_UI_OVERLAY_REALPATH" >> $KAFKA_ENV_FILE
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" >> $KAFKA_ENV_FILE


info "Kafka bootstrapping completed."
