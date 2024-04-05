# #! /bin/bash

#--------------------------------------#
# Clean script for Kafka               #
#                                      #  
# Removes all the modifications:       #
# - Deletes volumes                    #
#--------------------------------------#


# Initialization
KAFKA_SCRIPT_DIR=`dirname $0`
. $KAFKA_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
init_purge_flag

info "Kafka cleaning started."
. $KAFKA_SCRIPT_DIR/kafka-env.sh $KAFKA_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $KAFKA_SCRIPT_DIR/kafka-env.sh"

[ -f $KAFKA_ENV_FILE ] \
    && { rm $KAFKA_ENV_FILE && info "Docker environment file deleted: $KAFKA_ENV_FILE" || err "Unable to delete $KAFKA_ENV_FILE"; }\
    || info "File $KAFKA_ENV_FILE not present"


# Volumes reset
reset_volumes "kafka" $AVENIRS_KAFKA_VOLUMES_ROOT\
     $AVENIRS_ZOOKEEPER_VOLUMES_ROOT


info "Kafka cleaning completed."