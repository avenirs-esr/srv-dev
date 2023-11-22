#! /bin/bash

#--------------------------------------#
# Settings for the openldap scripts         #
#--------------------------------------#
OPENLDAP_SCRIPT_DIR=$1
. $OPENLDAP_SCRIPT_DIR/../../../scripts/srv-dev-env.sh
OPENLDAP_VOLUMES_ROOT=$VOLUMES_ROOT/ldap
LDIF_CUSTOM_DIR=$OPENLDAP_VOLUMES_ROOT/container/service/slapd/assets/config/bootstrap/ldif/custom
LDIF_FILE=$LDIF_CUSTOM_DIR/openldap-fixtures.ldif
FIXTURES_SCRIPT_CMD="$OPENLDAP_SCRIPT_DIR/openldap-fixtures.sh -o $LDIF_FILE"

# Docker env file
OPENLDAP_ENV_FILE=$OPENLDAP_SCRIPT_DIR/../.env

# Docker environment 
LDAP_ORGANISATION="avenirs-esr.fr"
LDAP_DOMAIN="ldap-dev.avenirs-esr.fr"
LDAP_BASE_DN="dc=ldap-dev,dc=avenirs-esr,dc=fr"

