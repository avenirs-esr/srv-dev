# #! /bin/bash

#--------------------------------------#
# Clean script for the dev env         #
#                                      #  
# Executes the clean script for each   #
# service                              #
#--------------------------------------#

SRV_DEV_SCRIPT_DIR=`dirname $0`

. $SRV_DEV_SCRIPT_DIR/srv-dev-commons.sh
init_help "`basename $0`" 
init_commons $*
. $SRV_DEV_SCRIPT_DIR/srv-dev-env.sh $SRV_DEV_SCRIPT_DIR 2> /dev/null || err "Unable to source $SRV_DEV_SCRIPT_DIR/srv-dev-env.sh"
init_services

# Clean a service
function clean_service(){
    local service=$1
    info "Cleaning service $service"
    local script=$SERVICES_ROOT/$service/scripts/$service-clean.sh
    vvverbose "Target script: $script"
    [ -e "$script" ] || err "script not found: $script"
    [ -x "$script" ] || err "script not executable: $script"
    info "Running: $script"
    $script
}

# Clean all services
function clean_services(){
    info "Cleaning started."
    vvverbose "Current directory $PWD"
    for service in $SERVICES 
    do
        clean_service $service
    done
     info "---"
    info "Cleaned services: $SERVICES"
    info "Completed"
}

clean_services