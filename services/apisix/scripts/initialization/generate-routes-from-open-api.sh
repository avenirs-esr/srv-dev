#!/bin/sh

# Section to adapt
SWAGGER_URL="http://avenirs-portfolio-api:10000/avenirs-portfolio-api/api-docs"
END_POINT="http://avenirs-apisix-api:9180/apisix/admin/routes"
AC_PLUGIN_ID="avenirs-access-control-mock"
COUNT_START=10
SWAGGER_URLS="http://avenirs-portfolio-api:10000/avenirs-portfolio-api/api-docs http://avenirs-portfolio-back-office:10010/avenirs-portfolio-back-office/api-docs"
# End Section to adapt

wait_for_endpoint() {
  local url="$1"
  local timeout=${2:-300}  # Timeout in seconds (default: 5 minutes)
  local interval=${3:-5}   # Interval between attempts in seconds (default: 5 seconds)
  local elapsed=0
  
  echo "Waiting for endpoint $url to be available..."
  
  while [ $elapsed -lt $timeout ]; do
    if curl -s --head --fail "$url" > /dev/null 2>&1; then
      echo "Endpoint $url is available!"
      return 0
    fi
    
    echo "Endpoint $url not available yet. Retrying in $interval seconds..."
    sleep $interval
    elapsed=$((elapsed + interval))
  done
  
  echo "Timeout reached. Endpoint $url is not available after $timeout seconds."
  return 1
}

GENERATE_FROM_SWAGGER_SCRIPT_DIR=`dirname $0`
OUTPUT_DIR="/scripts/"
OPEN_API_FILE="$GENERATE_FROM_SWAGGER_SCRIPT_DIR/openapi.nogit.json"
tags_line=''
count=0
i=$COUNT_START || 1


for SWAGGER_URL in $SWAGGER_URLS; do
  wait_for_endpoint "$SWAGGER_URL" 300 5 || exit 1
  echo "Fetching OpenAPI definition..."
  curl -s "$SWAGGER_URL" -o $OPEN_API_FILE
  echo "OpenAPI definition fetched in $OPEN_API_FILE."
  echo "Generating routes..."
  case "$SWAGGER_URL" in
    *avenirs-portfolio-api*) 
        SERVICE_PREFIX="api" 
        UPSTREAM_NODE="avenirs-portfolio-api:10000"
        tags_line='"labels": {"": "API"},'
        ;;
    *avenirs-portfolio-back-office*) 
      SERVICE_PREFIX="back-office" 
      i=100
      UPSTREAM_NODE="avenirs-portfolio-back-office:10010"
          tags_line='"labels": {"": "BACK-OFFICE"},'
      ;;
    *) 
     echo "ERROR: unknown service $SWAGGER_URL"
     exit 1
      ;;
  esac

  jq -c '
  .paths
  | to_entries[]
  | .key as $path
  | .value
  | to_entries[]
  | select(.value.operationId != null)
  | {
      uri: $path,
      method: (.key | ascii_upcase),
      operation: (.value.operationId | gsub("_"; "-") | ascii_downcase)
    }
  ' $OPEN_API_FILE | while read -r json; do
    uri=$(echo "$json" | jq -r '.uri')
    uri=$(echo "$uri" | sed -E 's/\{[^}]+\}/*/g')
    method=$(echo "$json" | jq -r '.method')
    operation=$(echo "$json" | jq -r '.operation')
    route_id="${SERVICE_PREFIX}-${operation}-route"
    script_name=$(printf "%02d-%s-%s.generated.curl.sh" "$i" "$SERVICE_PREFIX" "$operation")

    is_storage=false
    case "$uri" in
      /storage|/storage/*) is_storage=true ;;
    esac

    if [ "$is_storage" = true ] || [ "$SERVICE_PREFIX" != "api" ] ; then
      plugin_line=
    else
      plugin_line="\"plugin_config_id\": \"$AC_PLUGIN_ID\","
    fi

    cat > "$OUTPUT_DIR/$script_name" <<EOF
#! /bin/sh

END_POINT="$END_POINT"

curl -H "X-API-KEY: \$SEC_APISIX_ADMIN_KEY" -i "\$END_POINT" -X PUT -d '
{
  "name": "$route_id",
  "id": "$route_id",
  "uri": "$uri",
  "methods": ["$method", "OPTIONS"],
  "plugins": {
    "cors": {
      "_meta": {
        "disable": false
      },
      "allow_credential": false,
      "allow_headers": "*",
      "allow_methods": "*",
      "allow_origins": "*",
      "expose_headers": "*",
      "max_age": 5
    }
  },
  $plugin_line
  $tags_line
  "upstream": {
    "type": "roundrobin",
    "nodes": {
      "$UPSTREAM_NODE": 1
    }
  }
}'
EOF

    chmod +x "$OUTPUT_DIR/$script_name"
    echo "Endpoint: $method $uri -> $script_name (public=$is_storage)"
    count=$((count + 1))
    i=$((i + 1))
  done
done
rm $OPEN_API_FILE
echo "Routes generated"
echo "----"
count=$(ls -1 "$OUTPUT_DIR" | wc -l)
echo "$count scripts generated in $OUTPUT_DIR/"
