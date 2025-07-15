#! /bin/bash

#--------------------------------------#
# Settings for the openldap scripts    #
#                                      # 
# This file is also used by the cas    #
# service to determine the container   #
# name (dependency purpose)            #
#--------------------------------------#

OPENLDAP_SCRIPT_DIR=$1
. $OPENLDAP_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file
OPENLDAP_ENV_FILE=$OPENLDAP_SCRIPT_DIR/../.env

# Docker environment 
[ -z  "$LDAP_ORGANISATION" ] && LDAP_ORGANISATION="avenirs-esr.fr"
[ -z  "$LDAP_DOMAIN" ] && LDAP_DOMAIN="ldap-dev.avenirs-esr.fr"
[ -z  "$LDAP_BASE_DN" ] && LDAP_BASE_DN="dc=ldap-dev,dc=avenirs-esr,dc=fr"
[ -z  "$LDAP_READONLY_USER" ] && LDAP_READONLY_USER="true"
[ -z  "$LDAP_READONLY_USER_USERNAME" ] && LDAP_READONLY_USER_USERNAME="readonly"
[ -z  "$LDAP_READONLY_USER_PASSWORD" ] && LDAP_READONLY_USER_PASSWORD="readonly"
[ -z  "$AVENIRS_LDAP_FIXTURES_PASSWORD" ] && AVENIRS_LDAP_FIXTURES_PASSWORD='{ssha}Ke8lVwbkuJcEbWdCur8XLG9QwggNciz6UlwH/w==' #Azerty123
[ -z  "$AVENIRS_OPENLDAP_CONTAINER_NAME" ] && AVENIRS_OPENLDAP_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}openldap"
[ -z  "$AVENIRS_LDAP_ADMIN_CONTAINER_NAME" ] && AVENIRS_LDAP_ADMIN_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}phpldapadmin"
[ -z "$AVENIRS_LDAP_VOLUMES_ROOT" ] && AVENIRS_LDAP_VOLUMES_ROOT=$VOLUMES_ROOT/ldap

LDIF_CUSTOM_DIR=$AVENIRS_LDAP_VOLUMES_ROOT/container/service/slapd/assets/config/bootstrap/ldif/custom
LDIF_FILE=$LDIF_CUSTOM_DIR/openldap-fixtures.ldif
FIXTURES_SCRIPT_CMD="$OPENLDAP_SCRIPT_DIR/openldap-fixtures.sh -o $LDIF_FILE"

# This is to be sure that this script can be sourced.
return 0
