#! /bin/bash

#--------------------------------------#
# Settings for the CAS scripts         #
#--------------------------------------#
CAS_SCRIPT_DIR=$1

. $CAS_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

CAS_OVERLAY_DIR=$CAS_SCRIPT_DIR/../avenirs-cas-overlay
CAS_REPOSITORY_DIR=$CAS_SCRIPT_DIR/../cas-overlay-template
#CAS_REMOTE_BRANCH=remotes/origin/master
CAS_REMOTE_BRANCH=master
CAS_LOCAL_BRANCH=local
CAS_MAIN_BRANCH="master"

# Docker env file
CAS_ENV_FILE=$CAS_REPOSITORY_DIR/.env

# Container name
[ -z  "$AVENIRS_CAS_CONTAINER_NAME" ] && AVENIRS_CAS_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}cas"

CAS_SETTINGS_TEMPLATE_FILE=$CAS_OVERLAY_DIR/etc/cas/config/cas.properties.template
CAS_SETTINGS_FILE=$CAS_REPOSITORY_DIR/etc/cas/config/cas.properties


# This is to be sure that this script can be sourced.
return 0
