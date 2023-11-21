# #! /bin/bash

#--------------------------------------#
# Clean script for the dev env         #
#                                      #  
# Execute the clean scripts for each   #
# service                              #
#--------------------------------------#

SCRIPT_DIR=`dirname $0`

. $SCRIPT_DIR/commons.sh
init_help "`basename $0`" 
init_commons $*

SERVICES_ROOT="$SCRIPT_DIR/../services"