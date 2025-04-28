OS=$(detect_os)

vvverbose "Detected OS: $OS"

if [ "$OS" != "Windows" ]; then
  verbose "Update docker-compose.override.yml for non Windows OS..."

  sync_env_variables "./services/postgresql/.env" "./.env"

  add_service_volume "postgresql-primary" "\${AVENIRS_POSTGRESQL_ARCHIVE_VOLUME}:/var/lib/postgresql/archive"
  add_service_volume "postgresql-primary" "\${AVENIRS_POSTGRESQL_PRIMARY_VOLUME}:/var/lib/postgresql/data"
  add_service_volume "postgresql-secondary1" "\${AVENIRS_POSTGRESQL_ARCHIVE_VOLUME}:/var/lib/postgresql/archive"
  add_service_volume "postgresql-secondary1" "\${AVENIRS_POSTGRESQL_SECONDARY1_VOLUME}:/var/lib/postgresql/data"
  add_service_volume "postgresql-secondary2" "\${AVENIRS_POSTGRESQL_ARCHIVE_VOLUME}:/var/lib/postgresql/archive"
  add_service_volume "postgresql-secondary2" "\${AVENIRS_POSTGRESQL_SECONDARY2_VOLUME}:/var/lib/postgresql/data"

  verbose "docker-compose.override.yml updated successfully."
else
  vverbose "Windows. Skipping override generation. (Using default Docker named volumes)"
fi
