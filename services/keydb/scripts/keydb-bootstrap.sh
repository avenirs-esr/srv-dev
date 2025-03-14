#! /bin/bash

#--------------------------------------#
# KeyDB bootstrap                     #
#                                      #  
# - Docker volumes                     #
# - Docker .env file to set            #
#   environment from settings.         #
#--------------------------------------#

KEYDB_SCRIPT_DIR=`dirname $0`


# Initialization
. $KEYDB_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
info "KeyDB bootstrapping started."
. $KEYDB_SCRIPT_DIR/keydb-env.sh $KEYDB_SCRIPT_DIR || err "Unable to source $PWD/$KEYDB_SCRIPT_DIR/keydb-env.sh"

# Network check
check_network

# .env file generation
echo "AVENIRS_KEYDB_CONTAINER_NAME=$AVENIRS_KEYDB_CONTAINER_NAME" > $KEYDB_ENV_FILE
echo "AVENIRS_KEYDB_VOLUMES_ROOT=$AVENIRS_KEYDB_VOLUMES_ROOT" >> $KEYDB_ENV_FILE
echo "AVENIRS_KEYDB_DATA_VOLUME=$AVENIRS_KEYDB_DATA_VOLUME" >> $KEYDB_ENV_FILE
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" >> $KEYDB_ENV_FILE



# Volumes creation
init_volumes "keydb" $AVENIRS_KEYDB_DATA_VOLUME

# Probalement inutile
# chmod o+rw $AVENIRS_KEYDB_DATA_VOLUME && verbose "Permissions on $AVENIRS_KEYDB_DATA_VOLUME OK" || err "Unable to set the permission on $AVENIRS_KEYDB_DATA_VOLUME"

info "KeyDB bootstrapping completed."
