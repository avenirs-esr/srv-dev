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
[ -z  "$AVENIRS_APACHE_CONTAINER_NAME" ] && AVENIRS_APACHE_CONTAINER_NAME="apache"
[ -z  "$APACHE_OVERLAY_DIR" ] && APACHE_OVERLAY_DIR=$APACHE_SCRIPT_DIR/../avenirs-apache-overlay/
APACHE_OVERLAY_DIRNAME=`dirname $APACHE_OVERLAY_DIR`

# This is required to source this script as the test above can fail.
return 0
