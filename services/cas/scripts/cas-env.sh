#! /bin/bash

#--------------------------------------#
# Settings for the CAS scripts         #
#--------------------------------------#
CAS_SCRIPT_DIR=$1

. $CAS_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

CAS_OVERLAY_DIR=$CAS_SCRIPT_DIR/../avenirs-cas-overlay
CAS_REPOSITORY_DIR=$CAS_SCRIPT_DIR/../cas-overlay-template

# CAS_REMOTE_BRANCH=master
# CAS_LOCAL_BRANCH=local
# CAS_MAIN_BRANCH="master"

CAS_REMOTE_BRANCH=remotes/origin/8.0
CAS_LOCAL_BRANCH=8.0
CAS_MAIN_BRANCH="master"

# Docker env file
CAS_ENV_FILE=$CAS_REPOSITORY_DIR/.env

# Container name
[ -z  "$AVENIRS_CAS_CONTAINER_NAME" ] && AVENIRS_CAS_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}cas"

# Server name (CAS settings)
fqdn=$(hostname -f)
if [[ "$fqdn" =~ \.recia\.net$ ]]; then
    case "$fqdn" in
        *srv-dev*)
            AVENIRS_CAS_SERVER_NAME="https://dev.avenirs-esr.fr"
            ;;
        *srv-qualif*)
            AVENIRS_CAS_SERVER_NAME="https://qualif.avenirs-esr.fr"
            ;;
        *srv-recette*)
            AVENIRS_CAS_SERVER_NAME="https://recette.avenirs-esr.fr"
            ;;
        *)
            AVENIRS_CAS_SERVER_NAME="https://$fqdn"
            ;;
    esac
else
    AVENIRS_CAS_SERVER_NAME="https://localhost"
fi

CAS_SETTINGS_TEMPLATE_FILE=$CAS_OVERLAY_DIR/etc/cas/config/cas.properties.template
CAS_APIM_SERVICE_TEMPLATE_FILE=$CAS_OVERLAY_DIR/etc/cas/services/apim-4000.json.template



# This is to be sure that this script can be sourced.
return 0
