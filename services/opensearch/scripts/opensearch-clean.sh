# #! /bin/bash

#--------------------------------------#
#     Clean script for Opensearch      #
#                                      #
#--------------------------------------#


# Initialization
OPENSEARCH_SCRIPT_DIR=`dirname $0`
. $OPENSEARCH_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "Opensearch cleaning started."
. $OPENSEARCH_SCRIPT_DIR/opensearch-env.sh $OPENSEARCH_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $OPENSEARCH_SCRIPT_DIR/opensearch-env.sh"

[ -f $OPENSEARCH_ENV_FILE ] \
    && { rm $OPENSEARCH_ENV_FILE && info "Docker environment file deleted: $OPENSEARCH_ENV_FILE" || err "Unable to delete $OPENSEARCH_ENV_FILE"; }\
    || info "File $OPENSEARCH_ENV_FILE not present"

info "Opensearch cleaning completed."