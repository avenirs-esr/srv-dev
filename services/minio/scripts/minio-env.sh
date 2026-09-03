#! /bin/bash

#---------------------------------------------#
#    Settings for the MinIO service scripts   #
#---------------------------------------------#

MINIO_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $MINIO_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file.
MINIO_ENV_FILE=$MINIO_SCRIPT_DIR/../.env

# Docker environment.

# This is required to source this script as the test above can fail.
return 0
