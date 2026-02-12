# #! /bin/bash

#----------------------------------------#
# Bootstrap script for Avenirs portfolio #
#                                        #
#----------------------------------------#

AVENIRS_PORTFOLIO_SCRIPT_DIR=`dirname $0`

# Initialization
. $AVENIRS_PORTFOLIO_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
info "Avenirs portfolio bootstrapping started."

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

. $AVENIRS_PORTFOLIO_SCRIPT_DIR/avenirs-portfolio-env.sh $AVENIRS_PORTFOLIO_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $AVENIRS_PORTFOLIO_SCRIPT_DIR/avenirs-portfolio-env.sh"

# Network check
check_network

# .env file generation
write_env_file "JASYPT_ENCRYPTOR_PASSWORD" "$JASYPT_ENCRYPTOR_PASSWORD" ">" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_API_CONTAINER_NAME" "$AVENIRS_PORTFOLIO_API_CONTAINER_NAME" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_API_CONTAINER_PORT" "$AVENIRS_PORTFOLIO_API_CONTAINER_PORT" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_API_VERSION" "$AVENIRS_PORTFOLIO_API_VERSION" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_API_OVERLAY_DIR" "$AVENIRS_PORTFOLIO_API_OVERLAY_DIR" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_API_OVERLAY_BASENAME" "$AVENIRS_PORTFOLIO_API_OVERLAY_BASENAME" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE" "$AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"

write_env_file "AVENIRS_PORTFOLIO_BACK_OFFICE_CONTAINER_NAME" "$AVENIRS_PORTFOLIO_BACK_OFFICE_CONTAINER_NAME" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_BACK_OFFICE_CONTAINER_PORT" "$AVENIRS_PORTFOLIO_BACK_OFFICE_CONTAINER_PORT" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_BACK_OFFICE_OVERLAY_DIR" "$AVENIRS_PORTFOLIO_BACK_OFFICE_OVERLAY_DIR" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_BACK_OFFICE_OVERLAY_BASENAME" "$AVENIRS_PORTFOLIO_BACK_OFFICE_OVERLAY_BASENAME" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_BACK_OFFICE_SPRING_ENV_FILE" "$AVENIRS_PORTFOLIO_BACK_OFFICE_SPRING_ENV_FILE" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"

write_env_file "AVENIRS_PORTFOLIO_INTEROPERABILITY_CONTAINER_NAME" "$AVENIRS_PORTFOLIO_INTEROPERABILITY_CONTAINER_NAME" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_INTEROPERABILITY_CONTAINER_PORT" "$AVENIRS_PORTFOLIO_INTEROPERABILITY_CONTAINER_PORT" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_INTEROPERABILITY_OVERLAY_DIR" "$AVENIRS_PORTFOLIO_INTEROPERABILITY_OVERLAY_DIR" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_INTEROPERABILITY_OVERLAY_BASENAME" "$AVENIRS_PORTFOLIO_INTEROPERABILITY_OVERLAY_BASENAME" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_INTEROPERABILITY_SPRING_ENV_FILE" "$AVENIRS_PORTFOLIO_INTEROPERABILITY_SPRING_ENV_FILE" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"

# ---- avenirs-portfolio-api
# Spring env file generation
write_env_file "spring.datasource.url" "jdbc:postgresql://$AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME:5432/avenirs_api" ">" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
write_env_file "seeder.enabled" "true" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
write_env_file "avenirs.back-office.base-url" "http://$AVENIRS_PORTFOLIO_BACK_OFFICE_CONTAINER_NAME:10010/back-office" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
write_env_file "avenirs.interoperability.base-url" "http://$AVENIRS_PORTFOLIO_INTEROPERABILITY_CONTAINER_NAME:10020/interoperability" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
write_env_file "avenirs.interoperability.actuator.health" "http://$AVENIRS_PORTFOLIO_INTEROPERABILITY_CONTAINER_NAME:10020/actuator/health" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;

[ "`hostname`" = "srv-dev-avenir" ] && swagger_root="srv-dev-avenir.srv-avenir.brgm.recia.net" || swagger_root="localhost"
write_env_file "app.server.url" "http://$swagger_root/avenirs-portfolio-api" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
write_env_file "logging.level.org.springframework.web" "DEBUG" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
write_env_file "logging.level.org.springframework.web.filter.CommonsRequestLoggingFilter" "DEBUG" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
write_env_file "logging.level.org.springframework.security" "DEBUG" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
write_env_file "logging.level.org.springframework.security.web.FilterChainProxy" "DEBUG" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
write_env_file "rome.4.competence.client.id" "$SEC_AVENIRS_PORTFOLIO_API_ROME_4_CLIENT_ID" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
write_env_file "rome.4.competence.client.secret" "$SEC_AVENIRS_PORTFOLIO_API_ROME_4_CLIENT_SECRET" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
write_env_file "security.authentication.filter" "hmac" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;


# Overlay files
echo "install_overlay $AVENIRS_PORTFOLIO_API_OVERLAY_DIR $AVENIRS_PORTFOLIO_API_REPOSITORY_DIR"
install_overlay $AVENIRS_PORTFOLIO_API_OVERLAY_DIR $AVENIRS_PORTFOLIO_API_REPOSITORY_DIR

# ---- avenirs-portfolio-back-office
# Spring env file generation
write_env_file "spring.datasource.url" "jdbc:postgresql://$AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME:5432/avenirs_back_office" ">" $AVENIRS_PORTFOLIO_BACK_OFFICE_SPRING_ENV_FILE;
write_env_file "seeder.enabled" "true" ">>" $AVENIRS_PORTFOLIO_BACK_OFFICE_SPRING_ENV_FILE;
write_env_file "seeder.source" "FAKER" ">>" $AVENIRS_PORTFOLIO_BACK_OFFICE_SPRING_ENV_FILE;

[ "`hostname`" = "srv-dev-avenir" ] && swagger_root="srv-dev-avenir.srv-avenir.brgm.recia.net" || swagger_root="localhost"
write_env_file "app.server.url" "http://$swagger_root/avenirs-portfolio-back-office" ">>" $AVENIRS_PORTFOLIO_BACK_OFFICE_SPRING_ENV_FILE;
write_env_file  "security.authentication.filter" "disabled" ">>" $AVENIRS_PORTFOLIO_BACK_OFFICE_SPRING_ENV_FILE;

# Overlay files
echo "install_overlay $AVENIRS_PORTFOLIO_BACK_OFFICE_OVERLAY_DIR $AVENIRS_PORTFOLIO_BACK_OFFICE_REPOSITORY_DIR"
install_overlay $AVENIRS_PORTFOLIO_BACK_OFFICE_OVERLAY_DIR $AVENIRS_PORTFOLIO_BACK_OFFICE_REPOSITORY_DIR


# ---- avenirs-portfolio-interoperability
# Spring env file generation
write_env_file  "spring.datasource.url" "jdbc:postgresql://$AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME:5432/avenirs_interoperability" ">" $AVENIRS_PORTFOLIO_INTEROPERABILITY_SPRING_ENV_FILE;
write_env_file  "seeder.enabled" "true" ">>" $AVENIRS_PORTFOLIO_INTEROPERABILITY_SPRING_ENV_FILE;
write_env_file  "seeder.source" "CSV" ">>" $AVENIRS_PORTFOLIO_INTEROPERABILITY_SPRING_ENV_FILE;

[ "`hostname`" = "srv-dev-avenir" ] && swagger_root="srv-dev-avenir.srv-avenir.brgm.recia.net" || swagger_root="localhost"
write_env_file  "app.server.url" "http://$swagger_root/avenirs-portfolio-interoperability" ">>" $AVENIRS_PORTFOLIO_INTEROPERABILITY_SPRING_ENV_FILE;
write_env_file  "security.authentication.filter" "disabled" ">>" $AVENIRS_PORTFOLIO_INTEROPERABILITY_SPRING_ENV_FILE;

# Overlay files
echo "install_overlay $AVENIRS_PORTFOLIO_INTEROPERABILITY_OVERLAY_DIR $AVENIRS_PORTFOLIO_INTEROPERABILITY_REPOSITORY_DIR"
install_overlay $AVENIRS_PORTFOLIO_INTEROPERABILITY_OVERLAY_DIR $AVENIRS_PORTFOLIO_INTEROPERABILITY_REPOSITORY_DIR


# ---- avernirs-cofolio-client
write_env_file "AVENIRS_COFOLIO_CLIENT_CONTAINER_NAME" "$AVENIRS_COFOLIO_CLIENT_CONTAINER_NAME" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_COFOLIO_CLIENT_CONTAINER_PORT" "$AVENIRS_COFOLIO_CLIENT_CONTAINER_PORT" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_COFOLIO_CLIENT_OVERLAY_DIR" "$AVENIRS_COFOLIO_CLIENT_OVERLAY_DIR" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_COFOLIO_CLIENT_OVERLAY_BASENAME" "$AVENIRS_COFOLIO_CLIENT_OVERLAY_BASENAME" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"

# env file generation
write_env_file "VITE_API_URL" "$AVENIRS_PORTFOLIO_BACKEND_URL" ">" "$AVENIRS_COFOLIO_CLIENT_ENV_FILE"
write_env_file "VITE_ENABLE_MSW" "false" ">>" "$AVENIRS_COFOLIO_CLIENT_ENV_FILE"
write_env_file "VITE_BASE_PATH" "/cofolio/" ">>" "$AVENIRS_COFOLIO_CLIENT_ENV_FILE"
write_env_file "VITE_AVENIR_ESR_ACCESS_TOKEN" "AT-20-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r" ">>" "$AVENIRS_COFOLIO_CLIENT_ENV_FILE"
write_env_file "VITE_DEMO_MODE" "false" ">>" "$AVENIRS_COFOLIO_CLIENT_ENV_FILE"

echo "install_overlay $AVENIRS_COFOLIO_CLIENT_OVERLAY_DIR $AVENIRS_COFOLIO_CLIENT_REPOSITORY_DIR"
install_overlay $AVENIRS_COFOLIO_CLIENT_OVERLAY_DIR $AVENIRS_COFOLIO_CLIENT_REPOSITORY_DIR


# ---- avenirs-portfolio-security

# Network check
check_network


# .env file generation
write_env_file "AVENIRS_PORTFOLIO_SECURITY_CONTAINER_NAME" "$AVENIRS_PORTFOLIO_SECURITY_CONTAINER_NAME" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_SECURITY_CONTAINER_PORT" "$AVENIRS_PORTFOLIO_SECURITY_CONTAINER_PORT" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_SECURITY_VERSION" "$AVENIRS_PORTFOLIO_SECURITY_VERSION" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_SECURITY_OVERLAY_DIR" "$AVENIRS_PORTFOLIO_SECURITY_OVERLAY_DIR" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_SECURITY_OVERLAY_BASENAME" "$AVENIRS_PORTFOLIO_SECURITY_OVERLAY_BASENAME" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"
write_env_file "AVENIRS_PORTFOLIO_SECURITY_SPRING_ENV_FILE" "$AVENIRS_PORTFOLIO_SECURITY_SPRING_ENV_FILE" ">>" "$AVENIRS_PORTFOLIO_ENV_FILE"

# Spring env file generation
write_env_file "spring.datasource.url" "jdbc:postgresql://$AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME:5432/avenirs_access_control" ">" $AVENIRS_PORTFOLIO_SECURITY_SPRING_ENV_FILE;

[ "`hostname`" = "srv-dev-avenir" ] && swagger_root="srv-dev-avenir.srv-avenir.brgm.recia.net" || swagger_root="localhost"
write_env_file "app.server.url" "http://$swagger_root/avenirs-portfolio-security" ">>" $AVENIRS_PORTFOLIO_SECURITY_SPRING_ENV_FILE;

# Overlay files
echo "install_overlay $AVENIRS_PORTFOLIO_SECURITY_OVERLAY_DIR $AVENIRS_PORTFOLIO_SECURITY_REPOSITORY_DIR"
install_overlay $AVENIRS_PORTFOLIO_SECURITY_OVERLAY_DIR $AVENIRS_PORTFOLIO_SECURITY_REPOSITORY_DIR


# Database initialization files generation
info "Database initialization files generation for avenirs-portfolio-security"

cat $AVENIRS_PORTFOLIO_SECURITY_CLEAN_DB  > $AVENIRS_PORTFOLIO_SECURITY_CLEAN_DB_CLEAR
vverbose "Created $AVENIRS_PORTFOLIO_SECURITY_CLEAN_DB_CLEAR"

cat $AVENIRS_PORTFOLIO_SECURITY_CLEAN_TEST_DB  > $AVENIRS_PORTFOLIO_SECURITY_CLEAN_TEST_DB_CLEAR
vverbose "Created $AVENIRS_PORTFOLIO_SECURITY_CLEAN_TEST_DB_CLEAR"

$JASYPT_UTIL_SCRIPT $AVENIRS_PORTFOLIO_SECURITY_INIT_DB > $AVENIRS_PORTFOLIO_SECURITY_INIT_DB_CLEAR
vverbose "Created $AVENIRS_PORTFOLIO_SECURITY_INIT_DB_CLEAR"

$JASYPT_UTIL_SCRIPT $AVENIRS_PORTFOLIO_SECURITY_INIT_TEST_DB > $AVENIRS_PORTFOLIO_SECURITY_INIT_TEST_DB_CLEAR
vverbose "Created $AVENIRS_PORTFOLIO_SECURITY_INIT_TEST_DB_CLEAR"

info "Initialization files for avenirs-portfolio-security generated."

info "Database initialization files generation for avenirs-portfolio-api"

cat $AVENIRS_PORTFOLIO_API_CLEAN_DB  > $AVENIRS_PORTFOLIO_API_CLEAN_DB_CLEAR
vverbose "Created $AVENIRS_PORTFOLIO_API_CLEAN_DB_CLEAR"

$JASYPT_UTIL_SCRIPT $AVENIRS_PORTFOLIO_API_INIT_DB > $AVENIRS_PORTFOLIO_API_INIT_DB_CLEAR
vverbose "Created $AVENIRS_PORTFOLIO_API_INIT_DB_CLEAR"

info "Initialization files for avenirs-portfolio-api generated."


info "Database initialization files generation for avenirs-portfolio-back-office"

cat $AVENIRS_PORTFOLIO_BACK_OFFICE_CLEAN_DB  > $AVENIRS_PORTFOLIO_BACK_OFFICE_CLEAN_DB_CLEAR
vverbose "Created $AVENIRS_PORTFOLIO_BACK_OFFICE_CLEAN_DB_CLEAR"

$JASYPT_UTIL_SCRIPT $AVENIRS_PORTFOLIO_BACK_OFFICE_INIT_DB > $AVENIRS_PORTFOLIO_BACK_OFFICE_INIT_DB_CLEAR
vverbose "Created $AVENIRS_PORTFOLIO_BACK_OFFICE_INIT_DB_CLEAR"

info "Initialization files for avenirs-portfolio-back-office generated."


info "Database initialization files generation for avenirs-portfolio-interoperability"

cat $AVENIRS_PORTFOLIO_INTEROPERABILITY_CLEAN_DB  > $AVENIRS_PORTFOLIO_INTEROPERABILITY_CLEAN_DB_CLEAR
vverbose "Created $AVENIRS_PORTFOLIO_INTEROPERABILITY_CLEAN_DB_CLEAR"

$JASYPT_UTIL_SCRIPT $AVENIRS_PORTFOLIO_INTEROPERABILITY_INIT_DB > $AVENIRS_PORTFOLIO_INTEROPERABILITY_INIT_DB_CLEAR
vverbose "Created $AVENIRS_PORTFOLIO_INTEROPERABILITY_INIT_DB_CLEAR"

info "Initialization files for avenirs-portfolio-interoperability generated."

. $AVENIRS_PORTFOLIO_SCRIPT_DIR/init-storage-volume.sh

info "Avenirs portfolio bootstrapping completed."


