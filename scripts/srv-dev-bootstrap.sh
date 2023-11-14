# #! /bin/bash


# MODULES="apisix openldap"
MODULES="openldap"

SCRIPT_DIR=`dirname $0`



. $SCRIPT_DIR/commons.sh
init_commons $*



function deploy(){
    local module=$1
    info "Deploying module $module"
    local script=$module/scripts/$module-bootstrap.sh
    [ -e "$script" ] || err "script not found: $script"
    [ -x "$script" ] || err "script not executable: $script"
    $script
    info "running: $script"
}

for module in $MODULES 
do
    deploy $module
done
