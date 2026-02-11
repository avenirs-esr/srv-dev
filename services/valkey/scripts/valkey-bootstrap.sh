#! /bin/bash

#--------------------------------------#
#     Bootstrap script for Valkey      #  
#                                      #
#--------------------------------------#

VALKEY_SCRIPT_DIR=`dirname $0`


# Initialization
. $VALKEY_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`"
init_commons $*
info "Valkey bootstrapping started."

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

. $VALKEY_SCRIPT_DIR/valkey-env.sh $VALKEY_SCRIPT_DIR || err "Unable to source $PWD/$VALKEY_SCRIPT_DIR/valkey-env.sh"

# Network check
check_network

# .env file generation
echo "AVENIRS_NETWORK=$AVENIRS_NETWORK" > $VALKEY_ENV_FILE

info "Valkey bootstrapping completed."