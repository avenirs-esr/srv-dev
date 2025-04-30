OS=$(detect_os)

vvverbose "Detected OS: $OS"

if [ "$OS" = "Linux" ]; then
  verbose "Update docker-compose.override.yml for Linux..."

  sync_env_variables "./services/kafka/.env" "./.env"

  add_service_volume "zookeeper" "\${AVENIRS_ZOOKEEPER_VOLUMES_ROOT}/data:/var/lib/zookeeper/data"
  add_service_volume "zookeeper" "\${AVENIRS_ZOOKEEPER_VOLUMES_ROOT}/log:/var/lib/zookeeper/log"
  add_service_volume "kafka" "\${AVENIRS_KAFKA_VOLUMES_ROOT}/data:/var/lib/kafka/data"

  verbose "docker-compose.override.yml updated successfully."
else
  vverbose "Not Linux. Skipping override generation. (Using default Docker named volumes)"
fi
