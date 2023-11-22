# #! /bin/bash

#--------------------------------------#
# Clean script for APISIX              #
#                                      #  
# Removes all the modifications:       #
# - Reverts the modifications from the #
#   repository                         #
#--------------------------------------#

APISIX_SCRIPT_DIR=`dirname $0`

# Initialization
. $APISIX_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "APISIX cleaning started."
. $APISIX_SCRIPT_DIR/apisix-env.sh $APISIX_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $APISIX_SCRIPT_DIR/apisix-env.sh"


# Resets the repository
remove_overlay $OVERLAY_DIR $APISIX_REPOSITORY_DIR

info "APISIX cleaning completed."