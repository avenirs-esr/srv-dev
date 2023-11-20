# #! /bin/bash


SCRIPT_DIR=`dirname $0`
OVERLAY_DIR=$SCRIPT_DIR/../avenirs-apisix-overlay
TARGET_DIR=$SCRIPT_DIR/../apisix-docker


. $SCRIPT_DIR/../../../scripts/commons.sh
init_commons $*
info "APISIX bootstrapping started."
install_overlay $OVERLAY_DIR $TARGET_DIR

info "APISIX bootstrapping completed."

