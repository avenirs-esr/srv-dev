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
echo "AVENIRS_ZOOKEEPER_CONTAINER_NAME=$AVENIRS_ZOOKEEPER_CONTAINER_NAME" >> $KAFKA_ENV_FILE
echo "AVENIRS_ZOOKEEPER_VOLUMES_ROOT=$AVENIRS_ZOOKEEPER_VOLUMES_ROOT" >> $KAFKA_ENV_FILE
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" >> $KAFKA_ENV_FILE


# Volumes creation
mkdir -p  $AVENIRS_KAFKA_DATA_VOLUME && vverbose "Volume OK: $AVENIRS_KAFKA_DATA_VOLUME" || err "Unable to create $AVENIRS_KAFKA_DATA_VOLUME"
mkdir -p  $AVENIRS_ZOOKEEPER_DATA_VOLUME && vverbose "Volume OK: $AVENIRS_ZOOKEEPER_DATA_VOLUME" || err "Unable to create $AVENIRS_ZOOKEEPER_DATA_VOLUME"
mkdir -p  $AVENIRS_ZOOKEEPER_LOG_VOLUME && vverbose "Volume OK: $AVENIRS_ZOOKEEPER_LOG_VOLUME" || err "Unable to create $AVENIRS_ZOOKEEPER_LOG_VOLUME"

chmod o+rw $AVENIRS_KAFKA_DATA_VOLUME && verbose "Permissions on $AVENIRS_KAFKA_DATA_VOLUME OK" || err "Unable to set the permission on $AVENIRS_KAFKA_DATA_VOLUME"
chmod o+rw $AVENIRS_ZOOKEEPER_DATA_VOLUME && verbose "Permissions on $AVENIRS_ZOOKEEPER_DATA_VOLUME OK" || err "Unable to set the permission on $AVENIRS_ZOOKEEPER_DATA_VOLUME"
chmod o+rw $AVENIRS_ZOOKEEPER_LOG_VOLUME && verbose "Permissions on $AVENIRS_ZOOKEEPER_LOG_VOLUME OK" || err "Unable to set the permission on $AVENIRS_ZOOKEEPER_LOG_VOLUME"

info "Kafka bootstrapping completed."