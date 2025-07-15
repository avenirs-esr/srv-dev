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
init_git_repository $CAS_REPOSITORY_DIR $CAS_REMOTE_BRANCH $CAS_LOCAL_BRANCH

# Network check
check_network

# # CAS properties generation
export DYN_AVENIRS_OPENLDAP_CONTAINER_NAME=${AVENIRS_OPENLDAP_CONTAINER_NAME}
export DYN_AVENIRS_CAS_SERVER_NAME=${AVENIRS_CAS_SERVER_NAME}
substitute_secrets_and_dynamics $CAS_SETTINGS_TEMPLATE_FILE
substitute_secrets_and_dynamics $CAS_APIM_SERVICE_TEMPLATE_FILE

# Overlay files
install_overlay $CAS_OVERLAY_DIR $CAS_REPOSITORY_DIR

# .env file generation
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" > $CAS_ENV_FILE
echo "AVENIRS_CAS_CONTAINER_NAME=$AVENIRS_CAS_CONTAINER_NAME">> $CAS_ENV_FILE

info "CAS bootstrapping completed."