# #! /bin/bash

#--------------------------------------#
# Clean script for Openldap            #
#                                      #  
# Removes all the modifications:       #
# - Deletes volumes                    #
#--------------------------------------#

OPENLDAP_SCRIPT_DIR=`dirname $0`
. $OPENLDAP_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh

# Initialization
init_commons $*
info "Openldap cleaning started."
. $OPENLDAP_SCRIPT_DIR/openldap-env.sh $OPENLDAP_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $OPENLDAP_SCRIPT_DIR/openldap-env.sh"


warn "Deleting volume root: $BOLD $VOLUMES_ROOT $NC in 4 seconds. (CtrL + C to abort)"; 
sleep 4; 

sudo rm -Rf $VOLUMES_ROOT && info "$VOLUMES_ROOT deleted" || err "Unable to delete volumes root: $VOLUME_ROOT"


info "APISIX cleaning completed."