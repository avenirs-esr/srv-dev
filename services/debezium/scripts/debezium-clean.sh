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

info "Debezium cleaning completed."