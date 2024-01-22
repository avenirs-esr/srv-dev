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
init_git_repository $CAS_REPOSITORY_DIR $REMOTE_CAS_BRANCH $LOCAL_CAS_BRANCH

# Network check
check_network

# CAS properties generation
cat $CAS_SETTINGS_TEMPLATE_FILE | \
    sed s/__AVENIRS_OPENLDAP_CONTAINER_NAME__/${AVENIRS_OPENLDAP_CONTAINER_NAME}/g > \
    $CAS_SETTINGS_FILE

# Overlay files
install_overlay $CAS_OVERLAY_DIR $CAS_REPOSITORY_DIR

# .env file generation
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" > $CAS_ENV_FILE
echo "AVENIRS_CAS_CONTAINER_NAME=$AVENIRS_CAS_CONTAINER_NAME">> $CAS_ENV_FILE

info "CAS bootstrapping completed."