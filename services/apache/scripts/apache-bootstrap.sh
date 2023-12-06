#! /bin/bash

#--------------------------------------#
# Apache bootstrap                     #
#                                      #  
# - Docker volumes                     #
# - Docker .env file to set            #
#   environment from settings.         #
#--------------------------------------#

APACHE_SCRIPT_DIR=`dirname $0`


# Initialization
. $APACHE_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
info "Apache bootstrapping started."
. $APACHE_SCRIPT_DIR/apache-env.sh $APACHE_SCRIPT_DIR || err "Unable to source $PWD/$APACHE_SCRIPT_DIR/apache-env.sh"

# Network check
check_network

# .env file generation
echo "AVENIRS_APACHE_CONTAINER_NAME=$AVENIRS_APACHE_CONTAINER_NAME" > $APACHE_ENV_FILE
echo "APACHE_OVERLAY_DIR=$APACHE_OVERLAY_DIR" >> $APACHE_ENV_FILE
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" >> $APACHE_ENV_FILE



info "Apache bootstrapping completed."