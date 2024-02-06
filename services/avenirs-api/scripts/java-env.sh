#! /bin/bash

#--------------------------------------#
# Settings for the node service scripts#
#--------------------------------------#

AVENIRS_API_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $AVENIRS_API_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file.
AVENIRS_API_ENV_FILE=$AVENIRS_API_SCRIPT_DIR/../.env

# Root of the spring boot api project.
AVENIRS_API_API_ROOT=$AVENIRS_API_SCRIPT_DIR/../avenirs-api
return 0
