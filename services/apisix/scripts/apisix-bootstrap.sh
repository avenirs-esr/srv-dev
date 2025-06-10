# #! /bin/bash

#--------------------------------------#
# Bootstrap script APISIS              #
#                                      #  
# Copy the files from the overlay      #
# directory to the repository          #
#--------------------------------------#

APISIX_SCRIPT_DIR=`dirname $0`

# Initialization
. $APISIX_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "APISIX bootstrapping started."

. $APISIX_SCRIPT_DIR/apisix-env.sh $APISIX_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $APISIX_SCRIPT_DIR/apisix-env.sh"

# Initialization of the local branch of apisix if needed.
cd $APISIX_REPOSITORY_DIR || err "Unable to enter $APISIX_REPOSITORY_DIR"
if [ -z "`git branch   | grep $APISIX_LOCAL_BRANCH`" ]
then
    verbose "Switching to branch $APISIX_REMOTE_BRANCH (local branch $APISIX_LOCAL_BRANCH)"
    git checkout -B $APISIX_LOCAL_BRANCH $APISIX_REMOTE_BRANCH || err "unable to create branch $APISIX_LOCAL_BRANCH from $APISIX_REMOTE_BRANCH"
else 
    verbose "Local APISIX branch found $APISIX_LOCAL_BRANCH"
fi
cd - >/dev/null

# git branches for APISIX and APISIX UI
init_git_repository $APISIX_REPOSITORY_DIR $APISIX_REMOTE_BRANCH $APISIX_LOCAL_BRANCH
# 01/12/2023 commit 3e0929987f5d1078
#init_git_repository $APISIX_UI_REPOSITORY_DIR $APISIX_UI_REMOTE_BRANCH $APISIX_UI_LOCAL_BRANCH

# Network check
check_network

# Generates APISIX config file with specified apis keys
. $APISIX_SCRIPT_DIR/../secret_env || err "Unable to load secret_env. This file can be downloaded from vault or generated from secret_env.sample"
cat $APISIX_CONFIG_TEMPLATE | sed "s/__APISIX_ADMIN_KEY__/$APISIX_ADMIN_KEY/g" | sed "s/__APISIX_VIEWER_KEY__/$APISIX_VIEWER_KEY/g" > $APISIX_CONFIG
[ $? -eq 0 ] && verbose "APISIX config file generated." || err "Unable to generate APISIX config file"


# Overlay files
install_overlay $APISIX_OVERLAY_DIR $APISIX_REPOSITORY_DIR
install_overlay $APISIX_UI_OVERLAY_DIR $APISIX_UI_REPOSITORY_DIR

# .env file generation
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" > $APISIX_ENV_FILE
echo "AVENIRS_APISIX_DASHBOARD_CONTAINER_NAME=$AVENIRS_APISIX_DASHBOARD_CONTAINER_NAME" >> $APISIX_ENV_FILE
echo "AVENIRS_APISIX_API_CONTAINER_NAME=$AVENIRS_APISIX_API_CONTAINER_NAME" >> $APISIX_ENV_FILE
echo "AVENIRS_APISIX_ETCD_CONTAINER_NAME=$AVENIRS_APISIX_ETCD_CONTAINER_NAME" >> $APISIX_ENV_FILE
echo "AVENIRS_APISIX_PROMETHEUS_CONTAINER_NAME=$AVENIRS_APISIX_PROMETHEUS_CONTAINER_NAME" >> $APISIX_ENV_FILE
echo "AVENIRS_APISIX_GRAFANA_CONTAINER_NAME=$AVENIRS_APISIX_GRAFANA_CONTAINER_NAME" >> $APISIX_ENV_FILE
echo "AVENIRS_APISIX_INIT_CONTAINER_NAME=$AVENIRS_APISIX_INIT_CONTAINER_NAME" >> $APISIX_ENV_FILE

info "APISIX bootstrapping completed."

