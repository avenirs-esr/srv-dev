#! /bin/bash

#--------------------------------------#
# Settings for the srv-dev scripts     #
#--------------------------------------#
SRV_DEV_SCRIPT_DIR=$1
SERVICES_ROOT="$SRV_DEV_SCRIPT_DIR/../services"
VOLUMES_ROOT=/var/lib/docker-containers/dev.avenirs-esr.fr

# ---- Avenirs environment variables that can be overridden
#AVENIRS_OPENLDAP_CONTAINER_NAME=""
#AVENIRS_LDAP_ADMIN_CONTAINER_NAME=""