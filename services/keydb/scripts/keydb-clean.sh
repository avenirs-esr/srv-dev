#! /bin/bash

#--------------------------------------#
# Clean script for KeyDB               #
#                                      #  
# Removes all the modifications:       #
# - Deletes volumes                    #
#--------------------------------------#


# Initialization
KEYDB_SCRIPT_DIR=`dirname $0`
. $KEYDB_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*

info "KeyDB cleaning started."
. $KEYDB_SCRIPT_DIR/keydb-env.sh $KEYDB_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $KEYDB_SCRIPT_DIR/keydb-env.sh"

[ -f $KEYDB_ENV_FILE ] \
    && { rm $KEYDB_ENV_FILE && info "Docker environment file deleted: $KEYDB_ENV_FILE" || err "Unable to delete $KEYDB_ENV_FILE"; }\
    || info "File $KEYDB_ENV_FILE not present"


# Volumes reset
reset_volumes "keydb" $AVENIRS_KEYDB_VOLUMES_ROOT


info "KeyDB cleaning completed."