# #! /bin/bash

#--------------------------------------#
# Clean script for Kafka               #
#                                      #  
# Removes all the modifications        #
#--------------------------------------#


# Initialization
KAFKA_SCRIPT_DIR=`dirname $0`
. $KAFKA_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*

info "Kafka cleaning started."
. $KAFKA_SCRIPT_DIR/kafka-env.sh $KAFKA_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $KAFKA_SCRIPT_DIR/kafka-env.sh"

[ -f $KAFKA_ENV_FILE ] \
    && { rm $KAFKA_ENV_FILE && info "Docker environment file deleted: $KAFKA_ENV_FILE" || err "Unable to delete $KAFKA_ENV_FILE"; }\
    || info "File $KAFKA_ENV_FILE not present"



info "Kafka cleaning completed."