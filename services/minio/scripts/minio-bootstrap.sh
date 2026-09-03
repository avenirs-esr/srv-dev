#! /bin/bash

#--------------------------------------#
#      Bootstrap script for MinIO      #
#                                      #
#--------------------------------------#

MINIO_SCRIPT_DIR=`dirname $0`


# Initialization
. $MINIO_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
info "MinIO bootstrapping started."

write_env_file () {
  local key="$1"
  local val="$2"
  local redirection_operator="$3"
  local env_file="$4"

  if [ "$OVERWRITE" = "true" ]; then
    echo "$key=$val" $redirection_operator $env_file
  else
    # Add the key only if it does not already exist
    if grep -Eq "^[[:space:]]*${key}=" "$env_file"; then
      vverbose "⏭️  ${key} already exists in $env_file, skipping"
    else
      printf '%s=%s\n' "$key" "$val" >> "$env_file"
      vverbose "➕ Adding ${key} to $env_file"
    fi
  fi
}

. $MINIO_SCRIPT_DIR/minio-env.sh $MINIO_SCRIPT_DIR || err "Unable to source $PWD/$MINIO_SCRIPT_DIR/minio-env.sh"

# Network check
check_network

# .env file generation
touch "$MINIO_ENV_FILE"
write_env_file "AVENIRS_NETWORK" "$AVENIRS_NETWORK" ">" "$MINIO_ENV_FILE"
write_env_file "AVENIRS_MINIO_CONTAINER_NAME" "$AVENIRS_MINIO_CONTAINER_NAME" ">>" "$MINIO_ENV_FILE"
write_env_file "AVENIRS_MINIO_INIT_CONTAINER_NAME" "$AVENIRS_MINIO_INIT_CONTAINER_NAME" ">>" "$MINIO_ENV_FILE"
write_env_file "AVENIRS_MINIO_CONTAINER_PORT" "$AVENIRS_MINIO_CONTAINER_PORT" ">>" "$MINIO_ENV_FILE"
write_env_file "AVENIRS_MINIO_CONSOLE_PORT" "$AVENIRS_MINIO_CONSOLE_PORT" ">>" "$MINIO_ENV_FILE"
write_env_file "AVENIRS_MINIO_ROOT_USER" "$AVENIRS_MINIO_ROOT_USER" ">>" "$MINIO_ENV_FILE"
write_env_file "AVENIRS_MINIO_ROOT_PASSWORD" "$AVENIRS_MINIO_ROOT_PASSWORD" ">>" "$MINIO_ENV_FILE"
write_env_file "AVENIRS_MINIO_BUCKET" "$AVENIRS_MINIO_BUCKET" ">>" "$MINIO_ENV_FILE"
write_env_file "AVENIRS_MINIO_REGION" "$AVENIRS_MINIO_REGION" ">>" "$MINIO_ENV_FILE"

info "MinIO bootstrapping completed."
