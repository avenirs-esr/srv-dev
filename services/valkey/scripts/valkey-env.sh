#! /bin/bash

#---------------------------------------------#
#   Settings for the Valkey service scripts   #
#---------------------------------------------#

VALKEY_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $VALKEY_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file.
VALKEY_ENV_FILE=$VALKEY_SCRIPT_DIR/../.env

# Docker environment.

# This is required to source this script as the test above can fail.
return 0
