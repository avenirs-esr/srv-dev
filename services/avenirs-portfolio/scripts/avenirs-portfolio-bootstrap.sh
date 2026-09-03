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
    if [ "$redirection_operator" = ">" ]; then
      printf '%s=%s\n' "$key" "$val" > "$env_file"
    else
      printf '%s=%s\n' "$key" "$val" >> "$env_file"
    fi
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

# Writes a key regardless of the --overwrite flag, replacing any previous value.
# Used for values that must rotate on every deployment run (e.g. the HMAC secret).
set_rotating_env_value () {
  local key="$1"
  local val="$2"
  local env_file="$3"

  touch "$env_file"
  grep -Ev "^[[:space:]]*${key}=" "$env_file" > "${env_file}.tmp"
  mv "${env_file}.tmp" "$env_file"
  printf '%s=%s\n' "$key" "$val" >> "$env_file"
  vverbose "🔄 Rotated ${key} in $env_file"
}

. $AVENIRS_PORTFOLIO_SCRIPT_DIR/avenirs-portfolio-env.sh $AVENIRS_PORTFOLIO_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $AVENIRS_PORTFOLIO_SCRIPT_DIR/avenirs-portfolio-env.sh"

# Network check
check_network

# HMAC secret, regenerated on every deployment and shared by all backend micro-services
# (api, back-office, interoperability, security) for internal signed-header authentication.
AVENIRS_PORTFOLIO_HMAC_SECRET=$(openssl rand -base64 32)
set_rotating_env_value "AVENIRS_PORTFOLIO_HMAC_SECRET" "$AVENIRS_PORTFOLIO_HMAC_SECRET" "$AVENIRS_PORTFOLIO_ENV_FILE"
# Also propagated to .secrets.env so the APISIX init container (avenirs-access-control-mock
# plugin) can sign the mocked security context with the same secret.
set_rotating_env_value "AVENIRS_PORTFOLIO_HMAC_SECRET" "$AVENIRS_PORTFOLIO_HMAC_SECRET" "$AVENIRS_PORTFOLIO_SCRIPT_DIR/../../../.secrets.env"

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
set_rotating_env_value "security.hmac.secret" "$AVENIRS_PORTFOLIO_HMAC_SECRET" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;

# File storage backend, driven by AVENIRS_PORTFOLIO_STORAGE_BACKEND (set in .secrets.env,
# defaulted in srv-dev-env.sh).
# The default pictures stay on the mounted volume in every case: the API serves them as
# Spring resource locations, so they never travel through the object storage.
grep -Ev "^[[:space:]]*file\.storage\.(type|s3\.)" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE > $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE.tmp
mv $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE.tmp $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE

case "$AVENIRS_PORTFOLIO_STORAGE_BACKEND" in
  local)
    info "avenirs-portfolio-api file storage: filesystem of the api container, no object storage"
    write_env_file "file.storage.type" "local" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    ;;
  minio)
    info "avenirs-portfolio-api file storage: local MinIO container ($AVENIRS_MINIO_CONTAINER_NAME)"
    write_env_file "file.storage.type" "s3" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    write_env_file "file.storage.s3.endpoint" "http://$AVENIRS_MINIO_CONTAINER_NAME:9000" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    write_env_file "file.storage.s3.region" "$AVENIRS_MINIO_REGION" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    write_env_file "file.storage.s3.bucket" "$AVENIRS_MINIO_BUCKET" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    write_env_file "file.storage.s3.access-key" "$AVENIRS_MINIO_ROOT_USER" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    write_env_file "file.storage.s3.secret-key" "$AVENIRS_MINIO_ROOT_PASSWORD" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    write_env_file "file.storage.s3.path-style-access" "true" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    ;;
  s3)
    info "avenirs-portfolio-api file storage: online S3 ($SEC_AVENIRS_PORTFOLIO_API_S3_ENDPOINT)"
    [ -n "$SEC_AVENIRS_PORTFOLIO_API_S3_ENDPOINT" ] \
      || err "AVENIRS_PORTFOLIO_STORAGE_BACKEND=s3 but SEC_AVENIRS_PORTFOLIO_API_S3_ENDPOINT is missing from .secrets.env"
    [ -n "$SEC_AVENIRS_PORTFOLIO_API_S3_BUCKET" ] \
      || err "AVENIRS_PORTFOLIO_STORAGE_BACKEND=s3 but SEC_AVENIRS_PORTFOLIO_API_S3_BUCKET is missing from .secrets.env"
    [ -n "$SEC_AVENIRS_PORTFOLIO_API_S3_ACCESS_KEY" ] \
      || err "AVENIRS_PORTFOLIO_STORAGE_BACKEND=s3 but SEC_AVENIRS_PORTFOLIO_API_S3_ACCESS_KEY is missing from .secrets.env"
    [ -n "$SEC_AVENIRS_PORTFOLIO_API_S3_SECRET_KEY" ] \
      || err "AVENIRS_PORTFOLIO_STORAGE_BACKEND=s3 but SEC_AVENIRS_PORTFOLIO_API_S3_SECRET_KEY is missing from .secrets.env"
    write_env_file "file.storage.type" "s3" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    write_env_file "file.storage.s3.endpoint" "$SEC_AVENIRS_PORTFOLIO_API_S3_ENDPOINT" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    write_env_file "file.storage.s3.region" "${SEC_AVENIRS_PORTFOLIO_API_S3_REGION:-eu-west-3}" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    write_env_file "file.storage.s3.bucket" "$SEC_AVENIRS_PORTFOLIO_API_S3_BUCKET" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    write_env_file "file.storage.s3.access-key" "$SEC_AVENIRS_PORTFOLIO_API_S3_ACCESS_KEY" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    write_env_file "file.storage.s3.secret-key" "$SEC_AVENIRS_PORTFOLIO_API_S3_SECRET_KEY" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    write_env_file "file.storage.s3.path-style-access" "${SEC_AVENIRS_PORTFOLIO_API_S3_PATH_STYLE_ACCESS:-true}" ">>" $AVENIRS_PORTFOLIO_API_SPRING_ENV_FILE;
    ;;
  *)
    err "Unknown AVENIRS_PORTFOLIO_STORAGE_BACKEND \"$AVENIRS_PORTFOLIO_STORAGE_BACKEND\" (expected minio, s3 or local)"
    ;;
esac


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
set_rotating_env_value "security.hmac.secret" "$AVENIRS_PORTFOLIO_HMAC_SECRET" $AVENIRS_PORTFOLIO_BACK_OFFICE_SPRING_ENV_FILE;

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
set_rotating_env_value "security.hmac.secret" "$AVENIRS_PORTFOLIO_HMAC_SECRET" $AVENIRS_PORTFOLIO_INTEROPERABILITY_SPRING_ENV_FILE;

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
set_rotating_env_value "security.hmac.secret" "$AVENIRS_PORTFOLIO_HMAC_SECRET" $AVENIRS_PORTFOLIO_SECURITY_SPRING_ENV_FILE;

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


