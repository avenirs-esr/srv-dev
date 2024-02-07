# #! /bin/bash

#--------------------------------------#
# Clean script for Avenirs API         #
#                                      #
#--------------------------------------#


# Initialization
AVENIRS_API_SCRIPT_DIR=`dirname $0`
. $AVENIRS_API_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "Avenirs API cleaning started."
. $AVENIRS_API_SCRIPT_DIR/avenirs-api-env.sh $AVENIRS_API_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $AVENIRS_API_SCRIPT_DIR/avenirs-api-env.sh"

[ -f $AVENIRS_API_ENV_FILE ] \
    && { rm $AVENIRS_API_ENV_FILE && info "Docker environment file deleted: $AVENIRS_API_ENV_FILE" || err "Unable to delete $AVENIRS_API_ENV_FILE"; }\
    || info "File $AVENIRS_API_ENV_FILE not present"


info "Avenirs API cleaning completed."