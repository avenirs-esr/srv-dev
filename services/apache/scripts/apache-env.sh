#! /bin/bash

#--------------------------------------#
# Settings for the openldap scripts         #
#--------------------------------------#

APACHE_SCRIPT_DIR=$1
. $APACHE_SCRIPT_DIR/../../../scripts/srv-dev-env.sh
AVENIRS_LDAP_VOLUMES_ROOT=$VOLUMES_ROOT/apache

# Docker env file
APACHE_ENV_FILE=$APACHE_SCRIPT_DIR/../.env


# Docker environment 
[ -z  "$AVENIRS_APACHE_CONTAINER_NAME" ] && AVENIRS_APACHE_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}apache"
[ -z  "$APACHE_OVERLAY_DIR" ] && APACHE_OVERLAY_DIR=$APACHE_SCRIPT_DIR/../avenirs-apache-overlay/
APACHE_OVERLAY_BASENAME=`basename $APACHE_OVERLAY_DIR`

# Apache envvars
APACHE_ENVVARS_FILE=$APACHE_OVERLAY_DIR/usr/local/apache2/bin/envvars

# Proxy settings files
APACHE_PROXY_SETTINGS_TEMPLATE_FILE=$APACHE_OVERLAY_DIR/conf/extra/avenirs.conf.template
APACHE_PROXY_SETTINGS_FILE=$APACHE_OVERLAY_DIR/conf/extra/avenirs.conf.no-git


# This is required to source this script as the test above can fail.
return 0
