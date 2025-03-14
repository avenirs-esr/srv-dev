#! /bin/bash

#--------------------------------------#
# Realtime worker bootstrap            #
#                                      #  
# - Docker .env file to set            #
#   environment from settings.         #
#--------------------------------------#

REALTIME_WORKER_SCRIPT_DIR=`dirname $0`


# Initialization
. $REALTIME_WORKER_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
info "Realtime worker bootstrapping started."
. $REALTIME_WORKER_SCRIPT_DIR/realtime-worker-env.sh $REALTIME_WORKER_SCRIPT_DIR || err "Unable to source $PWD/$REALTIME_WORKER_SCRIPT_DIR/realtime-worker-env.sh"

# Network check
check_network

# .env file generation
echo "AVENIRS_REALTIME_WORKER_CONTAINER_NAME=$AVENIRS_REALTIME_WORKER_CONTAINER_NAME" > $REALTIME_WORKER_ENV_FILE
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" >> $REALTIME_WORKER_ENV_FILE

info "Realtime worker bootstrapping completed."