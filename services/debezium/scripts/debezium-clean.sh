#! /bin/bash

#--------------------------------------#
# Clean script for Debezium             #
#                                      #  
# Resets the repository                #
#--------------------------------------#

DEBEZIUM_SCRIPT_DIR=`dirname $0`

# Initialization
. $DEBEZIUM_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "Debezium cleaning started."

[ -f $DEBEZIUM_ENV_FILE ] && { rm -f $DEBEZIUM_ENV_FILE && info "$DEBEZIUM_ENV_FILE removed" || err "Unable to remove $DEBEZIUM_ENV_FILE"; } \
|| info "$DEBEZIUM_ENV_FILE not present"

info "Debezium cleaning completed."