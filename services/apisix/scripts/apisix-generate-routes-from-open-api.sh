#!/bin/bash

# Section to adapt
SWAGGER_URL="http://localhost:10000/avenirs-portfolio-api/api-docs"
END_POINT="http://avenirs-apisix-api:9180/apisix/admin/routes"
PLUGIN_ID="avenirs-access-control-mock"
COUNT_START=10
# End Section to adapt


# Initialization
GENERATE_FROM_SWAGGER_SCRIPT_DIR=`dirname $0`
. $GENERATE_FROM_SWAGGER_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
OUTPUT_DIR="${GENERATE_FROM_SWAGGER_SCRIPT_DIR}/initialization"
OPEN_API_FILE="$GENERATE_FROM_SWAGGER_SCRIPT_DIR/openapi.nogit.json"
declare -i count=0
i=$COUNT_START || 1


[ -d "$OUTPUT_DIR" ] && verbose "Output directory $OUTPUT_DIR found." || err "Output directory $OUTPUT_DIR not found."
info "Fetching OpenAPI definition..."
curl -s "$SWAGGER_URL" -o $OPEN_API_FILE
info "OpenAPI definition fetched in $OPEN_API_FILE."
info "Generating routes..."


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
  route_id="${operation}-route"
  script_name=$(printf "%02d-%s.curl.sh" "$i" "$route_id")

  cat > "$OUTPUT_DIR/$script_name" <<EOF
#! /bin/sh

END_POINT="$END_POINT"

curl -H "X-API-KEY: \$APISIX_ADMIN_KEY" -i "\$END_POINT" -X PUT -d '
{
  "name": "$route_id",
  "id": "$route_id",
  "uri": "$uri",
  "methods": ["$method", "OPTIONS"],
  "plugin_config_id": "$PLUGIN_ID",
  "upstream": {
    "type": "roundrobin",
    "nodes": {
      "avenirs-portfolio-api:10000": 1
    }
  }
}'
EOF


  chmod +x "$OUTPUT_DIR/$script_name"
  echo "Endpoint: $method $uri -> $script_name"
  count=$((count + 1))
  i=$((i + 1))
done
echo "Routes generated"
echo "----"
count=$(ls -1 "$OUTPUT_DIR" | wc -l)
echo "$count scripts generated in $OUTPUT_DIR/"
