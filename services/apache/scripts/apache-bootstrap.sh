#! /bin/bash

#--------------------------------------#
# Apache bootstrap                     #
#                                      #  
# - Docker volumes                     #
# - Docker .env file to set            #
#   environment from settings.         #
#--------------------------------------#

APACHE_SCRIPT_DIR=`dirname $0`


# Initialization
. $APACHE_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
info "Apache bootstrapping started."
. $APACHE_SCRIPT_DIR/apache-env.sh $APACHE_SCRIPT_DIR || err "Unable to source $PWD/$APACHE_SCRIPT_DIR/apache-env.sh"


# Volumes creation
# mkdir -p  $AVENIRS_LDAP_VOLUMES_ROOT/var/lib/ldap && vverbose "Volume OK: $AVENIRS_LDAP_VOLUMES_ROOT/var/lib/ldap" 
# mkdir -p  $AVENIRS_LDAP_VOLUMES_ROOT/etc/ldap/slapd.d && vverbose "Volume OK: $AVENIRS_LDAP_VOLUMES_ROOT/etc/ldap/slapd.d" 
# mkdir -p  $AVENIRS_LDAP_VOLUMES_ROOT/container/service/slapd/assets/certs/ && vverbose "Volume OK: $AVENIRS_LDAP_VOLUMES_ROOT/container/service/slapd/assets/certs" 
# mkdir -p  $LDIF_CUSTOM_DIR && vverbose "Volume OK: $LDIF_CUSTOM_DIR" 

# .env file generation
echo "AVENIRS_APACHE_CONTAINER_NAME=$AVENIRS_APACHE_CONTAINER_NAME" >> $APACHE_ENV_FILE


info "Apache bootstrapping completed."