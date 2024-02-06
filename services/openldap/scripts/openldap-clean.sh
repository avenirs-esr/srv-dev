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
init_purge_flag

info "Openldap cleaning started."
. $OPENLDAP_SCRIPT_DIR/openldap-env.sh $OPENLDAP_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $OPENLDAP_SCRIPT_DIR/openldap-env.sh"


if [ $PURGE_FLAG -eq 1 ] 
then
    info "Purge option provided, containers' directories will be deleted"
    warn_and_wait "Deleting volume root: $BOLD $AVENIRS_LDAP_VOLUMES_ROOT $NC in 4 seconds. (CtrL + C to abort)"; 

    sudo rm -Rf $AVENIRS_LDAP_VOLUMES_ROOT && info "$AVENIRS_LDAP_VOLUMES_ROOT deleted" || err "Unable to delete Openldap volumes root: $AVENIRS_LDAP_VOLUMES_ROOT"
else
    info "Purge option not provided, containers' directories will not be deleted"
fi

[ -f $OPENLDAP_ENV_FILE ] \
    && { rm $OPENLDAP_ENV_FILE && info "Docker environment file deleted: $OPENLDAP_ENV_FILE" || err "Unable to delete $OPENLDAP_ENV_FILE"; }\
    || info "File $OPENLDAP_ENV_FILE not present"


info "Openldap cleaning completed."