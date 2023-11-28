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

function check_prerequisites(){
    # Checks the docker group
    [ -n "$DOCKER_GROUP" ] || err "DOCKER_GROUP is missing in srv-dev-env.sh"
    verbose "Using docker group: $DOCKER_GROUP"

    local entry=`cat /etc/group | grep -e "^$DOCKER_GROUP:"`
    
    [ -z "$entry" ] && err "Group $DOCKER_GROUP not found"
    verbose "Docker group \"$DOCKER_GROUP\" found"

    # Checks the docker volume roots
    [ -n "$VOLUMES_ROOT" ] || err "VOLUMES_ROOT is missing in srv-dev-env.sh"
    [ -e $VOLUMES_ROOT -a ! -d $VOLUMES_ROOT ] && err "Volumes root $VOLUMES_ROOT exists but is not a directory"
    
    if [ ! -e $VOLUMES_ROOT ]
    then
        vvverbose "Volumes root not found: $VOLUMES_ROOT, trying to create"
        sudo mkdir $VOLUMES_ROOT || err "Unable to create $VOLUMES_ROOT"
        sudo chgrp $DOCKER_GROUP $VOLUMES_ROOT || err "Unable to change owner group of $VOLUMES_ROOT to $DOCKER_GROUP"
        sudo chmod g+u $VOLUMES_ROOT || err "Unable to change permission on $VOLUMES_ROOT (chmod g+u)"
        sudo chmod g+s $VOLUMES_ROOT || err "Unable to change permission on $VOLUMES_ROOT (chmod g+s)"
        info "Volume root $VOLUMES_ROOT created."
    else    
        info "Volumes root checked $VOLUMES_ROOT"
    fi
 }

check_prerequisites

bootstrap_services