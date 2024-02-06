# #! /bin/bash

#--------------------------------------#
# Clean script for APACHE            #
#                                      #  
# Removes all the modifications:       #
# - Deletes volumes                    #
#--------------------------------------#


# Initialization
APACHE_SCRIPT_DIR=`dirname $0`
. $APACHE_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*


info "Apache cleaning started."
. $APACHE_SCRIPT_DIR/apache-env.sh $APACHE_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $APACHE_SCRIPT_DIR/apache-env.sh"

[ -f $APACHE_ENV_FILE ] \
    && { rm $APACHE_ENV_FILE && info "Docker environment file deleted: $APACHE_ENV_FILE" || err "Unable to delete $APACHE_ENV_FILE"; }\
    || info "File $APACHE_ENV_FILE not present"

[ -f $APACHE_PROXY_SETTINGS_FILE ] \
    && { rm $APACHE_PROXY_SETTINGS_FILE && info "Docker environment file deleted: $APACHE_PROXY_SETTINGS_FILE" || err "Unable to delete $APACHE_PROXY_SETTINGS_FILE"; }\
    || info "File $APACHE_PROXY_SETTINGS_FILE not present"

[ -f $APACHE_ENVVARS_FILE ] \
    && { rm $APACHE_ENVVARS_FILE && info "Apache envvars file deleted: $APACHE_ENVVARS_FILE" || err "Unable to delete $APACHE_ENVVARS_FILE"; }\
    || info "File $APACHE_ENVVARS_FILE not present"



info "Apache cleaning completed."