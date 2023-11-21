SCRIPT_DIR=`dirname $0`
TARGET_DIR=$SCRIPT_DIR/../apisix-docker


. $SCRIPT_DIR/../../../scripts/commons.sh
init_commons $*
info "APISIX cleaning started."
remove_overlay $OVERLAY_DIR $TARGET_DIR

info "APISIX cleaning completed."