# #! /bin/bash

#--------------------------------------#
# Bootstrap script for the dev env     #
#                                      #
# Executes the bootstrap script for    #
# each service                         #
#--------------------------------------#

SRV_DEV_SCRIPT_DIR=$(dirname $0)

# Initialization
. $SRV_DEV_SCRIPT_DIR/srv-dev-commons.sh
init_help "$(basename $0)" "[-s|--services service [-s|--service service (...)]"
init_commons $*
. $SRV_DEV_SCRIPT_DIR/srv-dev-env.sh $SRV_DEV_SCRIPT_DIR 2> /dev/null || err "Unable to source $SRV_DEV_SCRIPT_DIR/srv-dev-env.sh"
init_services

# Bootstrap a service
function bootstrap_service() {
    local service=$1
    info "Bootstrapping  service $service"
    local script=$SERVICES_ROOT/$service/scripts/$service-bootstrap.sh
    vvverbose "Target script: $script"
    [ -e "$script" ] || err "script not found: $script"
    [ -x "$script" ] || err "script not executable: $script"
    info "running: $script"
    $script
}

# Bootstrap all services
function bootstrap_services() {
    info "Boostrapping started."
    vvverbose "Current directory $PWD"
    for service in $SERVICES
    do
        bootstrap_service $service
    done
    info "---"
    info "Bootstrapped services: $SERVICES"
    info "Completed"
}

bootstrap_services