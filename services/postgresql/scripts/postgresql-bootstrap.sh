#! /bin/bash

#--------------------------------------#
# Postgresql bootstrap                 #
#                                      #  
# - Docker .env file to set            #
#   environment from settings.         #
#--------------------------------------#

POSTGRESQL_SCRIPT_DIR=`dirname $0`


# Initialization
. $POSTGRESQL_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
info "POSTGRESQL bootstrapping started."
. $POSTGRESQL_SCRIPT_DIR/postgresql-env.sh $POSTGRESQL_SCRIPT_DIR || err "Unable to source $PWD/$POSTGRESQL_SCRIPT_DIR/postgresql-env.sh"

# Network check
check_network
echo "==>$POSTGRESQL_ENV_FILE"

# .env file generation
echo "AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME=$AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME" > $POSTGRESQL_ENV_FILE
echo "AVENIRS_POSTGRESQL_SECONDARY1_CONTAINER_NAME=$AVENIRS_POSTGRESQL_SECONDARY1_CONTAINER_NAME" >> $POSTGRESQL_ENV_FILE
echo "AVENIRS_POSTGRESQL_SECONDARY2_CONTAINER_NAME=$AVENIRS_POSTGRESQL_SECONDARY2_CONTAINER_NAME" >> $POSTGRESQL_ENV_FILE
echo "POSTGRES_USER=$POSTGRES_USER" >> $POSTGRESQL_ENV_FILE
echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> $POSTGRESQL_ENV_FILE
echo "POSTGRES_DB=$POSTGRES_DB" >> $POSTGRESQL_ENV_FILE
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" >> $POSTGRESQL_ENV_FILE


info "POSTGRESQL bootstrapping completed."