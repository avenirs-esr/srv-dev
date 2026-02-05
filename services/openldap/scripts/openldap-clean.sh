# #! /bin/bash

#--------------------------------------#
# Clean script for Openldap            #
#                                      #  
# Removes all the modifications:       #
# - Deletes volumes                    #
#--------------------------------------#


# Initialization
OPENLDAP_SCRIPT_DIR=`dirname $0`
. $OPENLDAP_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*

info "Openldap cleaning started."
. $OPENLDAP_SCRIPT_DIR/openldap-env.sh $OPENLDAP_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $OPENLDAP_SCRIPT_DIR/openldap-env.sh"



[ -f $OPENLDAP_ENV_FILE ] \
    && { rm $OPENLDAP_ENV_FILE && info "Docker environment file deleted: $OPENLDAP_ENV_FILE" || err "Unable to delete $OPENLDAP_ENV_FILE"; }\
    || info "File $OPENLDAP_ENV_FILE not present"


info "Openldap cleaning completed."