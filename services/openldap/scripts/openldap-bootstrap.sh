#! /bin/bash
# #! /bin/bash

#--------------------------------------#
# CASBootstrap script CAS              #
#                                      #  
# Creatio nof the docker volume        #
# Creates the LDIF for the fixtures    #
#--------------------------------------#

OPENLDAP_SCRIPT_DIR=`dirname $0`

# VOLUMES_ROOT=/var/lib/docker-containers/dev.avenirs-esr.fr/ldap
# LDIF_CUSTOM_DIR=$VOLUMES_ROOT/container/service/slapd/assets/config/bootstrap/ldif/custom
# LDIF_FILE=$LDIF_CUSTOM_DIR/openldap-fixtures.ldif

# FIXTURES_SCRIPT_CMD="$OPENLDAP_SCRIPT_DIR/openldap-fixtures.sh -o $LDIF_FILE"

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
mkdir -p  $VOLUMES_ROOT/var/lib/ldap && vverbose "Volume OK: $VOLUMES_ROOT/var/lib/ldap" 
mkdir -p  $VOLUMES_ROOT/etc/ldap/slapd.d && vverbose "Volume OK: $VOLUMES_ROOT/etc/ldap/slapd.d" 
mkdir -p  $VOLUMES_ROOT/container/service/slapd/assets/certs/ && vverbose "Volume OK: $VOLUMES_ROOT/container/service/slapd/assets/certs" 
mkdir -p  $LDIF_CUSTOM_DIR && vverbose "Volume OK: $LDIF_CUSTOM_DIR" 

# Fixtures generation.
$FIXTURES_SCRIPT_CMD || err "Fixture command exited with error: $FIXTURES_SCRIPT_CMD."


info "Openldap bootstrapping completed."