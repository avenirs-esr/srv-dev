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

# Initialization of the local branch if needed.
cd $APISIX_REPOSITORY_DIR || err "Unable to enter $APISIX_REPOSITORY_DIR"
if [ -z "`git branch   | grep $LOCAL_APISIX_BRANCH`" ]
then
    verbose "Switching to branch $REMOTE_APISIX_BRANCH (local branch $LOCAL_APISIX_BRANCH)"
    git checkout -B $LOCAL_APISIX_BRANCH $REMOTE_APISIX_BRANCH || err "unable to create branch $LOCAL_APISIX_BRANCH from $REMOTE_APISIX_BRANCH"
else 
    verbose "Local APISIX branch found $LOCAL_APISIX_BRANCH"
fi
cd - >/dev/null

# Overlay files
install_overlay $APISIX_OVERLAY_DIR $APISIX_REPOSITORY_DIR

info "APISIX bootstrapping completed."

