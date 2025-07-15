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


SECRET_ENV=$PREREQUISITE_SCRIPT_DIR/../.secrets.env
SECRET_ENV_EXAMPLE=$SECRET_ENV.example



if [ -f $SECRET_ENV ]
then
    vverbose "Required file for secrets found: $SECRET_ENV"
else
    err "Required file for secrets not found: $SECRET_ENV\n\
    This file is not versioned, you need to download it from vaultwarden \n\
    or to create it manually from $SECRET_ENV_EXAMPLE."
fi
