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

# Removes the overlay's files
remove_overlay $APISIX_REPOSITORY_DIR  
remove_overlay $APISIX_UI_REPOSITORY_DIR  

# Resets the repository
reset_git_repository $APISIX_REPOSITORY_DIR $APISIX_MAIN_BRANCH $APISIX_LOCAL_BRANCH
reset_git_repository $APISIX_UI_REPOSITORY_DIR $APISIX_UI_MAIN_BRANCH $APISIX_UI_LOCAL_BRANCH

info "APISIX cleaning completed."