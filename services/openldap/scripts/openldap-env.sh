#! /bin/bash

#--------------------------------------#
# Settings for the openldap scripts         #
#--------------------------------------#
OPENLDAP_SCRIPT_DIR=$1
VOLUMES_ROOT=/var/lib/docker-containers/dev.avenirs-esr.fr/ldap
LDIF_CUSTOM_DIR=$VOLUMES_ROOT/container/service/slapd/assets/config/bootstrap/ldif/custom
LDIF_FILE=$LDIF_CUSTOM_DIR/openldap-fixtures.ldif
FIXTURES_SCRIPT_CMD="$OPENLDAP_SCRIPT_DIR/openldap-fixtures.sh -o $LDIF_FILE"

