#! /bin/bash

#--------------------------------------#
# Settings for the realtime-worker     # 
# service scripts                      #
#--------------------------------------#

REALTIME_WORKER_SCRIPT_DIR=$1

# Main settings file. The settings loaded from this file are not overridden.
. $REALTIME_WORKER_SCRIPT_DIR/../../../scripts/srv-dev-env.sh

# Docker env file.
REALTIME_WORKER_ENV_FILE=$REALTIME_WORKER_SCRIPT_DIR/../.env

# Root of the realtime-worker project and build dir.
REALTIME_WORKER_ROOT=$REALTIME_WORKER_SCRIPT_DIR/../avenirs-portfolio-realtime-worker
REALTIME_WORKER_BUILD_DIR=$REALTIME_WORKER_ROOT/dist

# Docker environment.
[ -z "$AVENIRS_REALTIME_WORKER_CONTAINER_NAME" ] && AVENIRS_REALTIME_WORKER_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}realtime-worker"
[ -z "$AVENIRS_REALTIME_WORKER_CONTAINER_PORT" ] && AVENIRS_REALTIME_WORKER_CONTAINER_PORT=8040
AVENIRS_REALTIME_WORKER_REMOTE_BRANCH=remotes/origin/main
AVENIRS_REALTIME_WORKER_LOCAL_BRANCH=local_main
AVENIRS_REALTIME_WORKER_MAIN_BRANCH="main"

# This is required to source this script as the test above can fail.
return 0
