# #! /bin/bash

#--------------------------------------#
# Clean script for Realtime worker     #
#                                      #
#--------------------------------------#


# Initialization
REALTIME_WORKER_SCRIPT_DIR=`dirname $0`
. $REALTIME_WORKER_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "Realtime worker cleaning started."
. $REALTIME_WORKER_SCRIPT_DIR/realtime-worker-env.sh $REALTIME_WORKER_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $REALTIME_WORKER_SCRIPT_DIR/realtime-worker-env.sh"

[ -f $REALTIME_WORKER_ENV_FILE ] \
    && { rm $REALTIME_WORKER_ENV_FILE && info "Docker environment file deleted: $REALTIME_WORKER_ENV_FILE" || err "Unable to delete $REALTIME_WORKER_ENV_FILE"; }\
    || info "File $REALTIME_WORKER_ENV_FILE not present"

info "Realtime worker cleaning completed."