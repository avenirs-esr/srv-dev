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

echo "OPENLDAP_ENV_FILE $PWD/$OPENLDAP_ENV_FILE"
warn_and_wait "Deleting volume root: $BOLD $AVENIRS_LDAP_VOLUMES_ROOT $NC in 4 seconds. (CtrL + C to abort)"; 

sudo rm -Rf $AVENIRS_LDAP_VOLUMES_ROOT && info "$AVENIRS_LDAP_VOLUMES_ROOT deleted" || err "Unable to delete Openldap volumes root: $AVENIRS_LDAP_VOLUMES_ROOT"

[ -f $OPENLDAP_ENV_FILE ] \
    && { rm $OPENLDAP_ENV_FILE && info "Docker environment file deleted: $OPENLDAP_ENV_FILE" || err "Unable to delete $OPENLDAP_ENV_FILE"; }\
    || info "File $OPENLDAP_ENV_FILE not present"


info "Openldap cleaning completed."