OS=$(detect_os)

echo "Detected OS: $OS"

if [ "$OS" = "Linux" ]; then
  echo "Update docker-compose.override.yml for Linux..."

  sync_env_variables "./services/kafka/.env" "./.env"

  add_service_volume "zookeeper" "\${AVENIRS_ZOOKEEPER_VOLUMES_ROOT}/data:/var/lib/zookeeper/data"
  add_service_volume "zookeeper" "\${AVENIRS_ZOOKEEPER_VOLUMES_ROOT}/log:/var/lib/zookeeper/log"
  add_service_volume "kafka" "\${AVENIRS_KAFKA_VOLUMES_ROOT}/data:/var/lib/kafka/data"

  echo "docker-compose.override.yml updated successfully."
else
  echo "Not Linux. Skipping override generation. (Using default Docker named volumes)"
fi
