# #! /bin/bash

#--------------------------------------#
# Check prerequisites script           #
#                                      #
# Executes the check prerequisites     #
# for each service  and display and    #
# fails with an explicit error message #
# if a prerequisite is not met.        #
#--------------------------------------#

PREREQUISITE_SCRIPT_DIR=$(dirname $0)

# Initialization
. $PREREQUISITE_SCRIPT_DIR/srv-dev-commons.sh
init_commons $*

SERVICE_DIR=$PREREQUISITE_SCRIPT_DIR/../services
APISIX_SECRET_ENV=$SERVICE_DIR/apisix/secret_env
APISIX_SECRET_ENV_TEMPLATE=services/apisix/secret_env.template



if [ -f $APISIX_SECRET_ENV ]
then
    vverbose "Required file for Apisix found: $APISIX_SECRET_ENV"
else
    err "Required file for Apisix not found: $APISIX_SECRET_ENV\n\
    This file is not versioned, you need to dowload it from vaultwarden \n\
    or to create it manually from $APISIX_SECRET_ENV_TEMPLATE."
fi
