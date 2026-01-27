#! /bin/bash


RELOAD_FIXTURES_SCRIPT_DIR=`dirname $0`
. $RELOAD_FIXTURES_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`" ""
init_commons $*


. $RELOAD_FIXTURES_SCRIPT_DIR/openldap-env.sh $RELOAD_FIXTURES_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $RELOAD_FIXTURES_SCRIPT_DIR/openldap-env.sh"

FIXTURES_FILEe="$LDIF_FILE"
DOCKER_LDIF_FILE="${LDIF_FILE#"$OPENLDAP_OVERLAY_DIR"}"

vverbose "Using fixtures file: $FIXTURES_FILE"

info "Resetting LDAP..."
info "Deleting existing entries"

docker exec -i ${AVENIRS_OPENLDAP_CONTAINER_NAME} ldapdelete -v -Y EXTERNAL -H ldapi:/// -r "ou=people,dc=ldap-dev,dc=avenirs-esr,dc=fr"

info "Extisting entries deleted."
info "Loading fixtures file: $FIXTURES_FILE" 
docker exec -i ${AVENIRS_OPENLDAP_CONTAINER_NAME} ldapadd -c -Y EXTERNAL -H ldapi:/// -f "$DOCKER_LDIF_FILE"
info "Done."

