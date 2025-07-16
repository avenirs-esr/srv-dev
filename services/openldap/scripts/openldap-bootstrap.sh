#!/usr/bin/env bash

#--------------------------------------#
# Openldap bootstrap                   #
#                                      #  
# - Docker volumes                     #
# - LDIF fixtures                      #
# - Docker .env file to set            #
#   environment from settings.         #
#--------------------------------------#

OPENLDAP_SCRIPT_DIR=`dirname $0`


# Initialization
. $OPENLDAP_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`" "[ -r | --reset ]" 
init_commons $*
info "Openldap bootstrapping started."
. $OPENLDAP_SCRIPT_DIR/openldap-env.sh $OPENLDAP_SCRIPT_DIR || err "Unable to source $PWD/$OPENLDAP_SCRIPT_DIR/openldap-env.sh"

. $OPENLDAP_SCRIPT_DIR/../../../.secrets.env || err "Unable to source $OPENLDAP_SCRIPT_DIR/../../../.secrets.env"

# Check fixtures script
[ -f $FIXTURES_SCRIPT ] || err "$FIXTURES_SCRIPT not found."
[ -x $FIXTURES_SCRIPT ] || err "$FIXTURES_SCRIPT NOT executable."

# Volumes creation
init_volumes "openldap" $AVENIRS_LDAP_VOLUMES_ROOT/var/lib/ldap \
    $AVENIRS_LDAP_VOLUMES_ROOT/etc/ldap/slapd.d \
    $AVENIRS_LDAP_VOLUMES_ROOT/container/service/slapd/assets/certs/ \
    $LDIF_CUSTOM_DIR

# Network check
check_network

# .env file generation
echo "AVENIRS_LDAP_VOLUMES_ROOT=$AVENIRS_LDAP_VOLUMES_ROOT" > $OPENLDAP_ENV_FILE
echo "LDAP_ORGANISATION=$LDAP_ORGANISATION" >> $OPENLDAP_ENV_FILE
echo "LDAP_DOMAIN=$LDAP_DOMAIN" >> $OPENLDAP_ENV_FILE
echo "LDAP_BASE_DN=$LDAP_BASE_DN" >> $OPENLDAP_ENV_FILE

echo "LDAP_READONLY_USER=$LDAP_READONLY_USER" >> $OPENLDAP_ENV_FILE
echo "LDAP_READONLY_USER_USERNAME=$LDAP_READONLY_USER_USERNAME" >> $OPENLDAP_ENV_FILE
echo "SEC_LDAP_ADMIN_PASSWORD=$SEC_LDAP_ADMIN_PASSWORD" >> $OPENLDAP_ENV_FILE
echo "SEC_LDAP_CONFIG_PASSWORD=$SEC_LDAP_CONFIG_PASSWORD" >> $OPENLDAP_ENV_FILE
echo "SEC_LDAP_READONLY_USER_PASSWORD=$SEC_LDAP_READONLY_USER_PASSWORD" >> $OPENLDAP_ENV_FILE
echo "AVENIRS_OPENLDAP_CONTAINER_NAME=$AVENIRS_OPENLDAP_CONTAINER_NAME" >> $OPENLDAP_ENV_FILE
echo "AVENIRS_LDAP_ADMIN_CONTAINER_NAME=$AVENIRS_LDAP_ADMIN_CONTAINER_NAME" >> $OPENLDAP_ENV_FILE
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" >> $OPENLDAP_ENV_FILE

# Fixtures generation.
$FIXTURES_SCRIPT_CMD || err "Fixture command exited with error: $FIXTURES_SCRIPT_CMD."

info "Openldap bootstrapping completed."