# #! /bin/bash

#--------------------------------------#
# Clean script for APACHE            #
#                                      #  
# Removes all the modifications:       #
# - Deletes volumes                    #
#--------------------------------------#


# Initialization
APACHE_SCRIPT_DIR=`dirname $0`
. $APACHE_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "Apache cleaning started."
. $APACHE_SCRIPT_DIR/apache-env.sh $APACHE_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $APACHE_SCRIPT_DIR/apache-env.sh"

echo "APACHE_ENV_FILE $PWD/$APACHE_ENV_FILE"
warn_and_wait "Deleting volume root: $BOLD $AVENIRS_APACHE_VOLUMES_ROOT $NC in 4 seconds. (CtrL + C to abort)"; 

sudo rm -Rf $AVENIRS_APACHE_VOLUMES_ROOT && info "$AVENIRS_APACHE_VOLUMES_ROOT deleted" || err "Unable to delete APACHE volumes root: $AVENIRS_APACHE_VOLUMES_ROOT"

[ -f $APACHE_ENV_FILE ] \
    && { rm $APACHE_ENV_FILE && info "Docker environment file deleted: $APACHE_ENV_FILE" || err "Unable to delete $APACHE_ENV_FILE"; }\
    || info "File $APACHE_ENV_FILE not present"


info "Apache cleaning completed."