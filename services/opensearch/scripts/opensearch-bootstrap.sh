#! /bin/bash

#--------------------------------------#
#   Bootstrap script for Opensearch    #  
#                                      #
#--------------------------------------#

OPENSEARCH_SCRIPT_DIR=`dirname $0`


# Initialization
. $OPENSEARCH_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
info "Opensearch bootstrapping started."

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

. $OPENSEARCH_SCRIPT_DIR/opensearch-env.sh $OPENSEARCH_SCRIPT_DIR || err "Unable to source $PWD/$OPENSEARCH_SCRIPT_DIR/opensearch-env.sh"

# Network check
check_network

# .env file generation
write_env_file "AVENIRS_OPENSEARCH_CONTAINER_NAME" "$AVENIRS_OPENSEARCH_CONTAINER_NAME" ">" "$OPENSEARCH_ENV_FILE"
write_env_file "AVENIRS_OPENSEARCH_CONTAINER_PORT" "$AVENIRS_OPENSEARCH_CONTAINER_PORT" ">>" "$OPENSEARCH_ENV_FILE"
write_env_file "AVENIRS_OPENSEARCH_DASHBOARDS_CONTAINER_NAME" "$AVENIRS_OPENSEARCH_DASHBOARDS_CONTAINER_NAME" ">>" "$OPENSEARCH_ENV_FILE"
write_env_file "AVENIRS_OPENSEARCH_DASHBOARDS_CONTAINER_PORT" "$AVENIRS_OPENSEARCH_DASHBOARDS_CONTAINER_PORT" ">>" "$OPENSEARCH_ENV_FILE"
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" >> $OPENSEARCH_ENV_FILE

info "Opensearch bootstrapping completed."