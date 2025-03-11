# #! /bin/bash

#--------------------------------------#
# Bootstrap script for Debezium        #
#                                      #  
# Initialize the repository and copy   #
# the files from the overlay directory #
# to the repository                    #
#--------------------------------------#

# Initialization
 DEBEZIUM_SCRIPT_DIR=`dirname $0`
. $DEBEZIUM_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`" 
init_commons $*
info "Debezium bootstrapping started."

info "Debezium bootstrapping completed."