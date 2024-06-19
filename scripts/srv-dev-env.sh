#! /bin/bash

#--------------------------------------#
# Settings for the srv-dev scripts     #
#--------------------------------------#
SRV_DEV_SCRIPT_DIR=$1
SERVICES_ROOT="$SRV_DEV_SCRIPT_DIR/../services"
DOCKER_GROUP="docker"



# Docker env file
SRV_DEV_ENV_FILE=$SRV_DEV_SCRIPT_DIR/../.env

# ---- Docker environment variables that can be overridden
# global
VOLUMES_ROOT=/var/lib/docker-containers/dev.avenirs-esr.fr
AVENIRS_NETWORK=avenirs-network
AVENIRS_CONTAINER_PREFIX=avenirs-
AVENIRS_OPENLDAP_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}openldap"
AVENIRS_LDAP_ADMIN_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}phpldapadmin"
AVENIRS_APACHE_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}apache"
AVENIRS_APISIX_CONTAINER_PREFIX="${AVENIRS_CONTAINER_PREFIX}apisix-"
AVENIRS_APISIX_DASHBOARD_CONTAINER_NAME="${AVENIRS_APISIX_CONTAINER_PREFIX}dashboard"
AVENIRS_APISIX_API_CONTAINER_NAME="${AVENIRS_APISIX_CONTAINER_PREFIX}api"
AVENIRS_APISIX_ETCD_CONTAINER_NAME="${AVENIRS_APISIX_CONTAINER_PREFIX}etcd"
AVENIRS_APISIX_PROMETHEUS_CONTAINER_NAME="${AVENIRS_APISIX_CONTAINER_PREFIX}prometheus"
AVENIRS_APISIX_GRAFANA_CONTAINER_NAME="${AVENIRS_APISIX_CONTAINER_PREFIX}grafana"
AVENIRS_POSTGRESQL_UI_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}pgsql-ui"
AVENIRS_CAS_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}cas"
AVENIRS_KAFKA_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}kafka"
AVENIRS_KAFKA_UI_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}kafka-ui"
AVENIRS_ZOOKEEPER_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}zookeeper"
AVENIRS_NODE_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}node"
AVENIRS_NODE_CONTAINER_PORT=8030
AVENIRS_WS_CONTAINER_PORT=8033
AVENIRS_API_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}api"
AVENIRS_API_CONTAINER_PORT=10001
AVENIRS_API_VERSION=0.0.1
AVENIRS_POSTGRESQL_PRIMARY_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}pgsql-primary"
AVENIRS_POSTGRESQL_SECONDARY1_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}pgsql-secondary1"
AVENIRS_POSTGRESQL_SECONDARY2_CONTAINER_NAME="${AVENIRS_CONTAINER_PREFIX}pgsql-secondary2"
AVENIRS_PORTFOLIO_STORAGE_CONTAINER_PORT=10001
AVENIRS_PORTFOLIO_STORAGE_VERSION=0.0.1
AVENIRS_PORTFOLIO_CONTAINER_PREFIX="${AVENIRS_CONTAINER_PREFIX}portfolio-"
AVENIRS_PORTFOLIO_STORAGE_CONTAINER_NAME="${AVENIRS_PORTFOLIO_CONTAINER_PREFIX}storage"



# Openldap
#LDAP_ORGANISATION=""
#LDAP_DOMAIN=""
#LDAP_BASE_DN=""
#LDAP_ADMIN_PASSWORD=""
#LDAP_CONFIG_PASSWORD=""
#LDAP_READONLY_USER=""
#LDAP_READONLY_USER_USERNAME=""
#LDAP_READONLY_USER_PASSWORD=""
#AVENIRS_LDAP_VOLUMES_ROOT=$VOLUMES_ROOT/ldap
#AVENIRS_LDAP_FIXTURES_PASSWORD=""
#AVENIRS_OPENLDAP_CONTAINER_NAME=""
#AVENIRS_LDAP_ADMIN_CONTAINER_NAME=""

# Kafka
#AVENIRS_KAFKA_VOLUMES_ROOT=$VOLUMES_ROOT/kafka
# AVENIRS_ZOOKEEPER_VOLUMES_ROOT=$VOLUMES_ROOT/zookeeper