#! /bin/bash

#--------------------------------------#
#     Bootstrap script for Grafana     #  
#                                      #
#--------------------------------------#

GRAFANA_SCRIPT_DIR=`dirname $0`


# Initialization
. $GRAFANA_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
info "Grafana bootstrapping started."

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

. $GRAFANA_SCRIPT_DIR/grafana-env.sh $GRAFANA_SCRIPT_DIR || err "Unable to source $PWD/$GRAFANA_SCRIPT_DIR/grafana-env.sh"

# Network check
check_network

# .env file generation
write_env_file "AVENIRS_GRAFANA_CONTAINER_NAME" "$AVENIRS_GRAFANA_CONTAINER_NAME" ">" "$GRAFANA_ENV_FILE"
write_env_file "AVENIRS_GRAFANA_CONTAINER_PORT" "$AVENIRS_GRAFANA_CONTAINER_PORT" ">>" "$GRAFANA_ENV_FILE"
write_env_file "GF_SECURITY_ADMIN_USER" "$GF_SECURITY_ADMIN_USER" ">>" "$GRAFANA_ENV_FILE"
write_env_file "GF_SECURITY_ADMIN_PASSWORD" "$GF_SECURITY_ADMIN_PASSWORD" ">>" "$GRAFANA_ENV_FILE"
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" >> $GRAFANA_ENV_FILE

info "Grafana bootstrapping completed."