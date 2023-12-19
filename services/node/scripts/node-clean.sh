# #! /bin/bash

#--------------------------------------#
# Clean script for Node                #
#                                      #
#--------------------------------------#


# Initialization
NODE_SCRIPT_DIR=`dirname $0`
. $NODE_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "Node cleaning started."
. $NODE_SCRIPT_DIR/node-env.sh $NODE_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $NODE_SCRIPT_DIR/node-env.sh"

[ -f $NODE_ENV_FILE ] \
    && { rm $NODE_ENV_FILE && info "Docker environment file deleted: $NODE_ENV_FILE" || err "Unable to delete $NODE_ENV_FILE"; }\
    || info "File $NODE_ENV_FILE not present"

info "Node cleaning completed."