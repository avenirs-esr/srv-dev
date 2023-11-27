#! /bin/bash

#--------------------------------------#
# Settings for the srv-dev scripts     #
#--------------------------------------#
SRV_DEV_SCRIPT_DIR=$1
SERVICES_ROOT="$SRV_DEV_SCRIPT_DIR/../services"
VOLUMES_ROOT=/var/lib/docker-containers/deletedev.avenirs-esr.fr
DOCKER_GROUP="docker"

# ---- Docker environment variables that can be overridden
# Openldap
#LDAP_ORGANISATION=""
#LDAP_DOMAIN=""
#LDAP_BASE_DN=""
#LDAP_ADMIN_PASSWORD=""
#LDAP_CONFIG_PASSWORD=""
#LDAP_READONLY_USER=""
#LDAP_READONLY_USER_USERNAME=""
#LDAP_READONLY_USER_PASSWORD=""
#AVENIRS_LDAP_FIXTURES_PASSWORD=""
#AVENIRS_OPENLDAP_CONTAINER_NAME=""
#AVENIRS_LDAP_ADMIN_CONTAINER_NAME=""
#AVENIRS_OPENLDAP_CONTAINER_NAME=""
#AVENIRS_LDAP_ADMIN_CONTAINER_NAME=""