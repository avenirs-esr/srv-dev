# #! /bin/bash
set -eo pipefail
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
initialize_override_file

# .env file generation
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" > $SRV_DEV_ENV_FILE

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
        # TODO: check exit statut(JASYPT)
    done
    info "---"
    info "Bootstrapped services: $SERVICES"
    info "Completed"
}

check_docker_group() {
    [ -n "$DOCKER_GROUP" ] || err "DOCKER_GROUP is missing in srv-dev-env.sh"
    verbose "Using docker group: $DOCKER_GROUP"
    local entry=""
    OS=$(detect_os)

    if [ $OS = "Mac" ]; then
        entry=$(dscl . -list /Groups | grep -e "^$DOCKER_GROUP$")
    else
        entry=$(grep -e "^$DOCKER_GROUP:" /etc/group)
    fi

    if [ -z "$entry" ]; then
        verbose "Group $DOCKER_GROUP not found"
        if [ $OS = "Mac" ]; then
            dscl . -create /Groups/$DOCKER_GROUP
        else
            groupadd $DOCKER_GROUP
        fi
        verbose "Group $DOCKER_GROUP created"
    else
        verbose "Docker group \"$DOCKER_GROUP\" found"
    fi
}

function check_prerequisites(){
    # Checks the docker group
    check_docker_group

    # Checks that the user is member of Docker group
    vvverbose "Checking that user $USER is member of docker group $DOCKER_GROUP"
    groups | grep -qw $DOCKER_GROUP
    [ $? -ne 0 ] && err "User $USER is not member of docker group $DOCKER_GROUP"
    verbose "User $USER is memberof docker group $DOCKER_GROUP"

    # Checks the docker volume roots
    [ -n "$VOLUMES_ROOT" ] || err "VOLUMES_ROOT is missing in srv-dev-env.sh"
    [ -e $VOLUMES_ROOT -a ! -d $VOLUMES_ROOT ] && err "Volumes root $VOLUMES_ROOT exists but is not a directory"

    if [ ! -e $VOLUMES_ROOT ]
    then
        vvverbose "Volumes root not found: $VOLUMES_ROOT, trying to create"
        sudo mkdir -p $VOLUMES_ROOT || err "Unable to create $VOLUMES_ROOT"
        sudo chgrp $DOCKER_GROUP $VOLUMES_ROOT || err "Unable to change owner group of $VOLUMES_ROOT to $DOCKER_GROUP"
        sudo chmod g+u $VOLUMES_ROOT || err "Unable to change permission on $VOLUMES_ROOT (chmod g+u)"
        sudo chmod g+s $VOLUMES_ROOT || err "Unable to change permission on $VOLUMES_ROOT (chmod g+s)"
        info "Volume root $VOLUMES_ROOT created."
    else
        info "Volumes root checked $VOLUMES_ROOT"
    fi
}

check_prerequisites
check_network
bootstrap_services
