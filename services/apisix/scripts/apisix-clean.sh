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
remove_overlay $APISIX_REPOSITORY_DIR
cd $APISIX_REPOSITORY_DIR
git checkout $MAIN_APISIX_BRANCH || err "Unabble to checkout $MAIN_APISIX_BRANCH"

[ -n "`git branch | grep $LOCAL_APISIX_BRANCH`" ] \
    && { git branch -d $LOCAL_APISIX_BRANCH || err "Unable to delete d$LOCAL_APISIX_BRANCH"; } \
    || verbose "Branch $LOCAL_APISIX_BRANCH not found"

cd - > /dev/null

info "APISIX cleaning completed."