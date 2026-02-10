# #! /bin/bash

#--------------------------------------#
#       Clean script for Valkey        #
#                                      #
#--------------------------------------#


# Initialization
VALKEY_SCRIPT_DIR=`dirname $0`
. $VALKEY_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "Valkey cleaning started."
. $VALKEY_SCRIPT_DIR/valkey-env.sh $VALKEY_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $VALKEY_SCRIPT_DIR/valkey-env.sh"

[ -f $VALKEY_ENV_FILE ] \
    && { rm $VALKEY_ENV_FILE && info "Docker environment file deleted: $VALKEY_ENV_FILE" || err "Unable to delete $VALKEY_ENV_FILE"; }\
    || info "File $VALKEY_ENV_FILE not present"

info "Valkey cleaning completed."