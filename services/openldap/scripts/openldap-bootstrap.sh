#! /bin/bash
# #! /bin/bash

#--------------------------------------#
# CASBootstrap script CAS              #
#                                      #  
# Creatio nof the docker volume        #
# Creates the LDIF for the fixtures    #
#--------------------------------------#

OPENLDAP_SCRIPT_DIR=`dirname $0`



# Initialization
. $OPENLDAP_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`" "[ -r | --reset ]" 
init_commons $*
info "Openldap bootstrapping started."
. $OPENLDAP_SCRIPT_DIR/openldap-env.sh $OPENLDAP_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $OPENLDAP_SCRIPT_DIR/openldap-env.sh"

# Checks
[ -f $FIXTURES_SCRIPT ] || err "$FIXTURES_SCRIPT not found."
[ -x $FIXTURES_SCRIPT ] || err "$FIXTURES_SCRIPT NOT executable."



# Volumes creation
mkdir -p  $OPENLDAP_VOLUMES_ROOT/var/lib/ldap && vverbose "Volume OK: $OPENLDAP_VOLUMES_ROOT/var/lib/ldap" 
mkdir -p  $OPENLDAP_VOLUMES_ROOT/etc/ldap/slapd.d && vverbose "Volume OK: $OPENLDAP_VOLUMES_ROOT/etc/ldap/slapd.d" 
mkdir -p  $OPENLDAP_VOLUMES_ROOT/container/service/slapd/assets/certs/ && vverbose "Volume OK: $OPENLDAP_VOLUMES_ROOT/container/service/slapd/assets/certs" 
mkdir -p  $LDIF_CUSTOM_DIR && vverbose "Volume OK: $LDIF_CUSTOM_DIR" 

# .env file generation
echo "OPENLDAP_VOLUMES_ROOT=$OPENLDAP_VOLUMES_ROOT" > $OPENLDAP_ENV_FILE
echo "LDAP_ORGANISATION=$LDAP_ORGANISATION" >> $OPENLDAP_ENV_FILE
echo "LDAP_DOMAIN=$LDAP_DOMAIN" >> $OPENLDAP_ENV_FILE
echo "LDAP_BASE_DN=$LDAP_BASE_DN" >> $OPENLDAP_ENV_FILE

# Fixtures generation.
$FIXTURES_SCRIPT_CMD || err "Fixture command exited with error: $FIXTURES_SCRIPT_CMD."


info "Openldap bootstrapping completed."