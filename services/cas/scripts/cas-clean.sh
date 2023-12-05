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

# Removes the overlay's files
remove_overlay $CAS_REPOSITORY_DIR  

# Repository reset
reset_git_repository $CAS_REPOSITORY_DIR $CAS_MAIN_BRANCH $CAS_LOCAL_BRANCH

info "CAS cleaning completed."