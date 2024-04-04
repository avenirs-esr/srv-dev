# #! /bin/bash

#--------------------------------------#
# Clean script for Postgresql          #
#                                      #  
# Removes all the modifications        #
#--------------------------------------#


# Initialization
POSTGRESQL_SCRIPT_DIR=`dirname $0`
. $POSTGRESQL_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*



info "Postgresql cleaning started."
. $POSTGRESQL_SCRIPT_DIR/postgresql-env.sh $POSTGRESQL_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $POSTGRESQL_SCRIPT_DIR/postgresql-env.sh"

[ -f $POSTGRESQL_ENV_FILE ] \
    && { rm $POSTGRESQL_ENV_FILE && info "Docker environment file deleted: $POSTGRESQL_ENV_FILE" || err "Unable to delete $POSTGRESQL_ENV_FILE"; }\
    || info "File $POSTGRESQL_ENV_FILE not present"


# Volumes reset
reset_volumes "postgresql" $AVENIRS_POSTGRESQL_PRIMARY_VOLUME \
    $AVENIRS_POSTGRESQL_ARCHIVE_VOLUME \
    $AVENIRS_POSTGRESQL_SECONDARY1_VOLUME \
    $AVENIRS_POSTGRESQL_SECONDARY2_VOLUME


info "Postgresql cleaning completed."