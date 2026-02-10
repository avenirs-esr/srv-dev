#! /bin/bash

#--------------------------------------#
#   Bootstrap script for Prometheus    #  
#                                      #
#--------------------------------------#

PROMETHEUS_SCRIPT_DIR=`dirname $0`


# Initialization
. $PROMETHEUS_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
info "Prometheus bootstrapping started."

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

. $PROMETHEUS_SCRIPT_DIR/prometheus-env.sh $PROMETHEUS_SCRIPT_DIR || err "Unable to source $PWD/$PROMETHEUS_SCRIPT_DIR/prometheus-env.sh"

# Network check
check_network

# .env file generation
write_env_file "AVENIRS_PROMETHEUS_CONTAINER_NAME" "$AVENIRS_PROMETHEUS_CONTAINER_NAME" ">" "$PROMETHEUS_ENV_FILE"
write_env_file "AVENIRS_PROMETHEUS_CONTAINER_PORT" "$AVENIRS_PROMETHEUS_CONTAINER_PORT" ">>" "$PROMETHEUS_ENV_FILE"
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" >> $PROMETHEUS_ENV_FILE

info "Prometheus bootstrapping completed."