# #! /bin/bash

#--------------------------------------#
#       Clean script for Grafana       #
#                                      #
#--------------------------------------#


# Initialization
GRAFANA_SCRIPT_DIR=`dirname $0`
. $GRAFANA_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "Grafana cleaning started."
. $GRAFANA_SCRIPT_DIR/grafana-env.sh $GRAFANA_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $GRAFANA_SCRIPT_DIR/grafana-env.sh"

[ -f $GRAFANA_ENV_FILE ] \
    && { rm $GRAFANA_ENV_FILE && info "Docker environment file deleted: $GRAFANA_ENV_FILE" || err "Unable to delete $GRAFANA_ENV_FILE"; }\
    || info "File $GRAFANA_ENV_FILE not present"

info "Grafana cleaning completed."