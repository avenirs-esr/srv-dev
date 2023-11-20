#! /bin/bash


SCRIPT_DIR=`dirname $0`

VOLUMES_ROOT=/var/lib/docker-containers/dev.avenirs-esr.fr/ldap
LDIF_CUSTOM_DIR=$VOLUMES_ROOT/container/service/slapd/assets/config/bootstrap/ldif/custom
LDIF_FILE=$LDIF_CUSTOM_DIR/openldap-fixtures.ldif

FIXTURES_SCRIPT_CMD="$SCRIPT_DIR/openldap-fixtures.sh -o $LDIF_FILE"

. $SCRIPT_DIR/../../../scripts/commons.sh
init_help "`basename $0`" "[ -r | --reset ]" 
init_commons $*


[ -f $FIXTURES_SCRIPT ] || err "$FIXTURES_SCRIPT not found."
[ -x $FIXTURES_SCRIPT ] || err "$FIXTURES_SCRIPT NOT executable."

[ "$1" = "--reset" || "$1" = "-r" ] && { warn "Deleting $VOLUME_ROOT in 4 seconds."; sleep 4; sudo rm -Rf $VOLUMES_ROOT && info "$VOLUMES_ROOT deleted"; }

mkdir -p  $VOLUMES_ROOT/var/lib/ldap && vverbose " > $VOLUMES_ROOT/var/lib/ldap" 
mkdir -p  $VOLUMES_ROOT/etc/ldap/slapd.d && vverbose " > $VOLUMES_ROOT/etc/ldap/slapd.d" 
mkdir -p  $VOLUMES_ROOT/container/service/slapd/assets/certs/ && vverbose " > $VOLUMES_ROOT/container/service/slapd/assets/certs" 
mkdir -p  $LDIF_CUSTOM_DIR && vverbose " > $LDIF_CUSTOM_DIR" 

$FIXTURES_SCRIPT_CMD || err "Fixture command exited with error."



info "Openldap container volumes created."