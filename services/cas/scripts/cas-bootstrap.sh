# #! /bin/bash

#--------------------------------------#
# CASBootstrap script CAS              #
#                                      #  
# Initialize the repository and copy   #
# the files from the overlay directory #
# to the repository                    #
#--------------------------------------#

# Initialization
 CAS_SCRIPT_DIR=`dirname $0`
. $CAS_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`" 
init_commons $*
info "CAS bootstrapping started."
. $CAS_SCRIPT_DIR/cas-env.sh $CAS_SCRIPT_DIR 2> /dev/null || err "Unable to source $CAS_SCRIPT_DIR/cas-env.sh"

# Initialization of the local branch if needed.
cd $CAS_REPOSITORY_DIR || err "Unable to enter $CAS_REPOSITORY_DIR"
if [ -z "`git branch  --show-current  | grep $LOCAL_CAS_BRANCH`" ]
then
    verbose "Switching to branch $REMOTE_CAS_BRANCH (local branch $LOCAL_CAS_BRANCH)"
    git checkout -B $LOCAL_CAS_BRANCH $REMOTE_CAS_BRANCH || err "unable to create branch $LOCAL_CAS_BRANCH from $REMOTE_CAS_BRANCH"
else 
    verbose "Local CAS branch found $LOCAL_CAS_BRANCH"
fi
cd - >/dev/null

# Overlay files
install_overlay $CAS_OVERLAY_DIR $CAS_REPOSITORY_DIR

info "CAS bootstrapping completed."