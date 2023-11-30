#! /bin/bash

#--------------------------------------#
# Settings for the APISIX scripts         #
#--------------------------------------#
APISIX_SCRIPT_DIR=$1
APISIX_OVERLAY_DIR=$APISIX_SCRIPT_DIR/../avenirs-apisix-overlay
APISIX_REPOSITORY_DIR=$APISIX_SCRIPT_DIR/../apisix-docker
REMOTE_APISIX_BRANCH=remotes/origin/release/apisix-3.6.0
LOCAL_APISIX_BRANCH=3.6.0
MAIN_APISIX_BRANCH="master"
