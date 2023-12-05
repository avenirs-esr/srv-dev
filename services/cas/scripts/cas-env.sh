#! /bin/bash

#--------------------------------------#
# Settings for the CAS scripts         #
#--------------------------------------#
CAS_SCRIPT_DIR=$1

. $CAS_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

CAS_OVERLAY_DIR=$CAS_SCRIPT_DIR/../avenirs-cas-overlay
CAS_REPOSITORY_DIR=$CAS_SCRIPT_DIR/../cas-overlay-template
CAS_REMOTE_BRANCH=remotes/origin/6.6
CAS_LOCAL_BRANCH=6.6
CAS_MAIN_BRANCH="master"

# Docker env file
CAS_ENV_FILE=$CAS_REPOSITORY_DIR/.env
