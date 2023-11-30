# #! /bin/bash

#--------------------------------------#
# Clean script for CAS                 #
#                                      #  
# Resets the repository                #
#--------------------------------------#

CAS_SCRIPT_DIR=`dirname $0`

# Initialization
. $CAS_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "CAS cleaning started."
. $CAS_SCRIPT_DIR/cas-env.sh $CAS_SCRIPT_DIR 2> /dev/null || err "Unable to source $CAS_SCRIPT_DIR/cas-env.sh"


# Repository reset
remove_overlay $CAS_REPOSITORY_DIR
cd $CAS_REPOSITORY_DIR
git checkout $MAIN_CAS_BRANCH || err "Unabble to checkout $MAIN_CAS_BRANCH"

[ -n "`git branch | grep $LOCAL_CAS_BRANCH`" ] \
    && { git branch -d $LOCAL_CAS_BRANCH || err "Unable to delete d$LOCAL_CAS_BRANCH"; } \
    || verbose "Branch $LOCAL_CAS_BRANCH not found"

cd - > /dev/null

info "CAS cleaning completed."