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

# Initialization of the local branch of apisix if needed.
cd $APISIX_REPOSITORY_DIR || err "Unable to enter $APISIX_REPOSITORY_DIR"
if [ -z "`git branch   | grep $LOCAL_APISIX_BRANCH`" ]
then
    verbose "Switching to branch $REMOTE_APISIX_BRANCH (local branch $LOCAL_APISIX_BRANCH)"
    git checkout -B $LOCAL_APISIX_BRANCH $REMOTE_APISIX_BRANCH || err "unable to create branch $LOCAL_APISIX_BRANCH from $REMOTE_APISIX_BRANCH"
else 
    verbose "Local APISIX branch found $LOCAL_APISIX_BRANCH"
fi
cd - >/dev/null

# git branches for APISIX and APISIX UI
init_git_branch $APISIX_REPOSITORY_DIR $REMOTE_APISIX_BRANCH $LOCAL_APISIX_BRANCH
init_git_branch $APISIX_UI_REPOSITORY_DIR $REMOTE_APISIX_UI_BRANCH $LOCAL_APISIX_UI_BRANCH
# Initialization of the local branch of apisix-ui if needed.
# cd $APISIX_REPOSITORY_DIR || err "Unable to enter $APISIX_REPOSITORY_DIR"
# if [ -z "`git branch   | grep $LOCAL_APISIX_BRANCH`" ]
# then
#     verbose "Switching to branch $REMOTE_APISIX_BRANCH (local branch $LOCAL_APISIX_BRANCH)"
#     git checkout -B $LOCAL_APISIX_BRANCH $REMOTE_APISIX_BRANCH || err "unable to create branch $LOCAL_APISIX_BRANCH from $REMOTE_APISIX_BRANCH"
# else 
#     verbose "Local APISIX branch found $LOCAL_APISIX_BRANCH"
# fi
# cd - >/dev/null

# Network check
check_network

# Overlay files
install_overlay $APISIX_OVERLAY_DIR $APISIX_REPOSITORY_DIR

# .env file generation
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" > $APISIX_ENV_FILE

info "APISIX bootstrapping completed."

