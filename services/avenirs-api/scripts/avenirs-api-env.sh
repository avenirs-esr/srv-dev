#! /bin/bash

#--------------------------------------#
# Settings for the node service scripts#
#--------------------------------------#

AVENIRS_API_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $AVENIRS_API_SCRIPT_DIR/../../../scripts/srv-dev-env.sh


# Docker environment 
[ -z  "$AVENIRS_API_CONTAINER_NAME" ] && AVENIRS_API_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}api"
[ -z  "$AVENIRS_API_VERSION" ] && AVENIRS_API_VERSION="0.0.1"
[ -z  "$AVENIRS_API_OVERLAY_DIR" ] && AVENIRS_API_OVERLAY_DIR=$AVENIRS_API_SCRIPT_DIR/../avenirs-api-overlay/
AVENIRS_OVERLAY_BASENAME=`basename $AVENIRS_API_OVERLAY_DIR`

# Git submodule.
AVENIRS_API_REPOSITORY_DIR=$APISIX_SCRIPT_DIR/../avenirs-api

# Docker env file.
AVENIRS_API_ENV_FILE=$AVENIRS_API_SCRIPT_DIR/../.env

# Spring boot env file
AVENIRS_API_SPRING_ENV_FILE=$AVENIRS_API_SCRIPT_DIR/../avenirs-api-overlay/src/main/resources/env.properties.no-git

# Root of the spring boot api project.
AVENIRS_API_API_ROOT=$AVENIRS_API_SCRIPT_DIR/../avenirs-api
return 0
