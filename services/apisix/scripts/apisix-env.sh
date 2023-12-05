#! /bin/bash

#--------------------------------------#
# Settings for the APISIX scripts         #
#--------------------------------------#
APISIX_SCRIPT_DIR=$1

. $APISIX_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

APISIX_OVERLAY_DIR=$APISIX_SCRIPT_DIR/../avenirs-apisix-overlay/apisix-docker
APISIX_REPOSITORY_DIR=$APISIX_SCRIPT_DIR/../apisix-docker
APISIX_REMOTE_BRANCH=remotes/origin/release/apisix-3.6.0
APISIX_LOCAL_BRANCH=3.6.0
APISIX_MAIN_BRANCH="master"
APISIX_ENV_FILE=$APISIX_REPOSITORY_DIR/example/.env
APISIX_UI_OVERLAY_DIR=$APISIX_SCRIPT_DIR/../avenirs-apisix-overlay/apisix-dashboard
APISIX_UI_REPOSITORY_DIR=$APISIX_SCRIPT_DIR/../apisix-dashboard
APISIX_UI_REMOTE_BRANCH=remotes/origin/release/3.0
APISIX_UI_LOCAL_BRANCH=3.0
APISIX_UI_MAIN_BRANCH="master"
