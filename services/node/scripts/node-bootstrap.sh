#! /bin/bash

#--------------------------------------#
# Node bootstrap                       #
#                                      #  
# - Docker .env file to set            #
#   environment from settings.         #
#--------------------------------------#

NODE_SCRIPT_DIR=`dirname $0`


# Initialization
. $NODE_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
info "NODE bootstrapping started."
. $NODE_SCRIPT_DIR/node-env.sh $NODE_SCRIPT_DIR || err "Unable to source $PWD/$NODE_SCRIPT_DIR/node-env.sh"

# Network check
check_network

# .env file generation
echo "AVENIRS_NODE_CONTAINER_NAME=$AVENIRS_NODE_CONTAINER_NAME" > $NODE_ENV_FILE
echo "AVENIRS_NODE_CONTAINER_PORT=$AVENIRS_NODE_CONTAINER_PORT" >> $NODE_ENV_FILE
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" >> $NODE_ENV_FILE

info "Node bootstrapping completed."