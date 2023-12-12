#! /bin/bash

#--------------------------------------#
# Settings for the APISIX scripts      #
#--------------------------------------#
APISIX_SCRIPT_DIR=$1

# Global settings file. The settings loaded from this file are not overridden.
. $APISIX_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker settings. Can be overridden in srv-dev.env.sh
[ -z "$AVENIRS_APISIX_CONTAINER_PREFIX" ] && AVENIRS_APISIX_CONTAINER_PREFIX="${AVENIRS_CONTAINER_PREFIX}apisix-"
[ -z "$AVENIRS_APISIX_DASHBOARD_CONTAINER_NAME" ] && AVENIRS_APISIX_DASHBOARD_CONTAINER_NAME="${AVENIRS_APISIX_CONTAINER_PREFIX}dashboard"
[ -z "$AVENIRS_APISIX_API_CONTAINER_NAME" ] && AVENIRS_APISIX_API_CONTAINER_NAME="${AVENIRS_APISIX_API_CONTAINER_NAME}api"
[ -z "$AVENIRS_APISIX_ETCD_CONTAINER_NAME" ] && AVENIRS_APISIX_ETCD_CONTAINER_NAME="${AVENIRS_APISIX_ETCD_CONTAINER_NAME}etcd"
[ -z "$AVENIRS_APISIX_PROMETHEUS_CONTAINER_NAME" ] && AVENIRS_APISIX_PROMETHEUS_CONTAINER_NAME="${AVENIRS_APISIX_CONTAINER_PREFIX}prometheus"
[ -z "$AVENIRS_APISIX_GRAFANA_CONTAINER_NAME" ] && AVENIRS_APISIX_GRAFANA_CONTAINER_NAME="${AVENIRS_APISIX_CONTAINER_PREFIX}grafana"

# Git submodules.
APISIX_REPOSITORY_DIR=$APISIX_SCRIPT_DIR/../apisix-docker

# Docker env file.
APISIX_ENV_FILE=$APISIX_REPOSITORY_DIR/example/.env

# Git submodule / local / remote branches and overlay settings.
APISIX_UI_OVERLAY_DIR=$APISIX_SCRIPT_DIR/../avenirs-apisix-overlay/apisix-dashboard
APISIX_OVERLAY_DIR=$APISIX_SCRIPT_DIR/../avenirs-apisix-overlay/apisix-docker
APISIX_REMOTE_BRANCH=remotes/origin/release/apisix-3.6.0
APISIX_LOCAL_BRANCH=3.6.0
APISIX_MAIN_BRANCH="master"
APISIX_UI_REPOSITORY_DIR=$APISIX_SCRIPT_DIR/../apisix-dashboard
APISIX_UI_REMOTE_BRANCH=remotes/origin/release/3.0
APISIX_UI_LOCAL_BRANCH=3.0
APISIX_UI_MAIN_BRANCH="master"
