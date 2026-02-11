# #! /bin/bash

#--------------------------------------#
#     Clean script for Prometheus      #
#                                      #
#--------------------------------------#


# Initialization
PROMETHEUS_SCRIPT_DIR=`dirname $0`
. $PROMETHEUS_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "Prometheus cleaning started."
. $PROMETHEUS_SCRIPT_DIR/prometheus-env.sh $PROMETHEUS_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $PROMETHEUS_SCRIPT_DIR/prometheus-env.sh"

[ -f $PROMETHEUS_ENV_FILE ] \
    && { rm $PROMETHEUS_ENV_FILE && info "Docker environment file deleted: $PROMETHEUS_ENV_FILE" || err "Unable to delete $PROMETHEUS_ENV_FILE"; }\
    || info "File $PROMETHEUS_ENV_FILE not present"

info "Prometheus cleaning completed."