#! /bin/bash

#--------------------------------------#
# Settings for the KeyDB scripts       #
#--------------------------------------#

KEYDB_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $KEYDB_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file.
KEYDB_ENV_FILE=$KEYDB_SCRIPT_DIR/../.env

# Docker environment.
[ -z "$AVENIRS_KEYDB_CONTAINER_NAME" ] && AVENIRS_KEYDB_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}keydb"
[ -z "$AVENIRS_KEYDB_VOLUMES_ROOT" ] && AVENIRS_KEYDB_VOLUMES_ROOT=$VOLUMES_ROOT/keydb
[ -z "$AVENIRS_KEYDB_DATA_VOLUME" ] && AVENIRS_KEYDB_DATA_VOLUME=$AVENIRS_KEYDB_VOLUMES_ROOT/data


# This is required to source this script as the test above can fail.
return 0
