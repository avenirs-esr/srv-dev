# #! /bin/bash


SCRIPT_DIR=`dirname $0`
OVERLAY_DIR=$SCRIPT_DIR/../avenirs-cas-overlay
TARGET_DIR=$SCRIPT_DIR/../cas-overlay-template


. $SCRIPT_DIR/../../scripts/commons.sh
init_commons $*
install_overlay $OVERLAY_DIR $TARGET_DIR

info "CAS bootstrapping completed."