# #! /bin/bash



SCRIPT_DIR=`dirname $0`

. $SCRIPT_DIR/commons.sh
init_help "`basename $0`" 
init_commons $*

SERVICES_ROOT="$SCRIPT_DIR/../services"

## Uncomment to use specific services
#SERVICES="$SERVICES_ROOT/apisix $SERVICES_ROOT/cas $SERVICES_ROOT/openldap"

[ -z "$SERVICES" ] &&   { cd $SERVICES_ROOT && SERVICES=`ls -d *` && cd - >/dev/null || err "Unable to set the services"; }  




vverbose "Services: $SERVICES"


function deploy(){
    local service=$1
    info "Deploying service $service"
    local script=$SERVICES_ROOT/$service/scripts/$service-bootstrap.sh
    vvverbose "Target script: $script"
    [ -e "$script" ] || err "script not found: $script"
    [ -x "$script" ] || err "script not executable: $script"
    info "running: $script"
    $script
}


for service in $SERVICES 
do
    deploy $service
done
