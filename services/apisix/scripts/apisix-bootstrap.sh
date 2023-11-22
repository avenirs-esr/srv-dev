# #! /bin/bash

#--------------------------------------#
# Bootstrap script APISIS              #
#                                      #  
# Copy the files from the overlay      #
# directory to the repository          #
#--------------------------------------#

APISIX_SCRIPT_DIR=`dirname $0`

# Initialization
. $APISIX_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "APISIX bootstrapping started."

. $APISIX_SCRIPT_DIR/apisix-env.sh $APISIX_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $APISIX_SCRIPT_DIR/apisix-env.sh"

# Overlay files
install_overlay $APISIX_OVERLAY_DIR $APISIX_REPOSITORY_DIR

info "APISIX bootstrapping completed."

