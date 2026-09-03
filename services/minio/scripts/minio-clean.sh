#! /bin/bash

#--------------------------------------#
#        Clean script for MinIO        #
#                                      #
#--------------------------------------#


# Initialization
MINIO_SCRIPT_DIR=`dirname $0`
. $MINIO_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "MinIO cleaning started."
. $MINIO_SCRIPT_DIR/minio-env.sh $MINIO_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $MINIO_SCRIPT_DIR/minio-env.sh"

[ -f $MINIO_ENV_FILE ] \
    && { rm $MINIO_ENV_FILE && info "Docker environment file deleted: $MINIO_ENV_FILE" || err "Unable to delete $MINIO_ENV_FILE"; }\
    || info "File $MINIO_ENV_FILE not present"

info "MinIO cleaning completed."
