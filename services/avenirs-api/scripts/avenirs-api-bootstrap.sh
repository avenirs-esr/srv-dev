#! /bin/bash

#--------------------------------------#
# Avenirs API bootstrap                #
#                                      #  
# - Docker .env file to set            #
#   environment from settings.         #
#--------------------------------------#

AVENIRS_API_SCRIPT_DIR=`dirname $0`


# Initialization
. $AVENIRS_API_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
info "Avenirs API bootstrapping started."
. $AVENIRS_API_SCRIPT_DIR/avenirs-api-env.sh $AVENIRS_API_SCRIPT_DIR || err "Unable to source $PWD/$AVENIRS_API_SCRIPT_DIR/avenirs-api-env.sh"

# Network check
check_network

# .env file generation
echo "AVENIRS_API_CONTAINER_NAME=$AVENIRS_API_CONTAINER_NAME" > $AVENIRS_API_ENV_FILE
echo "AVENIRS_API_CONTAINER_PORT=$AVENIRS_API_CONTAINER_PORT" >> $AVENIRS_API_ENV_FILE
echo "AVENIRS_API_VERSION=$AVENIRS_API_VERSION" >> $AVENIRS_API_ENV_FILE
echo "AVENIRS_API_OVERLAY_DIR=$AVENIRS_API_OVERLAY_DIR" >> $AVENIRS_API_ENV_FILE
echo "AVENIRS_OVERLAY_BASENAME=$AVENIRS_OVERLAY_BASENAME" >> $AVENIRS_API_ENV_FILE
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" >> $AVENIRS_API_ENV_FILE

echo "avenirs.kafka.bootstrap-servers=avenirs-kafka:9092" > $AVENIRS_API_SPRING_ENV_FILE;

info "Avenirs API bootstrapping completed."