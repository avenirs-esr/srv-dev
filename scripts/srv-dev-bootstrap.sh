# #! /bin/bash


MODULES="apisix cas"
#MODULES="cas"

SCRIPT_DIR=`dirname $0`



. $SCRIPT_DIR/commons.sh
init_commons $*



function deploy(){
    local module=$1
    info "Deploying module $module"
    local script=$module/scripts/$module-bootstrap.sh
    [ -e "$script" ] || err "script not found: $script"
    [ -x "$script" ] || err "script not executable: $script"
    info "running: $script"
    $script
}

for module in $MODULES 
do
    deploy $module
done
