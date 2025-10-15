#! /bin/sh

ROUTES_INIT_SCRIPT_DIR=$1


echo "----"
date
echo "APISIX Routes initialization started."
echo "----"
echo "Waiting for APISIX to be ready..."
MAX_RETRIES=10
RETRY_COUNT=0
RETRY_INTERVAL=5
APISIX_END_POINT="http://avenirs-apisix-api:9180/apisix/admin/routes"

while [ $RETRY_COUNT -lt $MAX_RETRIES ]
do
  echo "Attempt $((RETRY_COUNT+1))/$MAX_RETRIES..."
  
  if curl -s -o /dev/null -w "%{http_code}" -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" $APISIX_END_POINT | grep -q "401\|200"; then
    echo "APISIX is ready!"
    break
  else
    echo "APISIX not ready yet, waiting $RETRY_INTERVAL seconds..."
    sleep $RETRY_INTERVAL
    RETRY_COUNT=$((RETRY_COUNT+1))
  fi
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
  echo "ERROR APISIX did not become ready after $MAX_RETRIES attempts."
  echo "ERROR APISIX routes NOT initialized"
  exit 1
fi
echo "Removing existing routes..."
echo "curl -s -H \"X-API-KEY: $SEC_APISIX_ADMIN_KEY\" \
  \"$APISIX_END_POINT?page=1&page_size=500\""
curl -s -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" \
  "$APISIX_END_POINT?page=1&page_size=500" \
| jq -r '.list[]? | .value.id' \
| xargs -r -n1 -I{} curl -s -H "X-API-KEY: $SEC_APISIX_ADMIN_KEY" -X DELETE "$APISIX_END_POINT/{}"
echo "Routes removed."

echo "APISIX Routes initialization: launching curl scripts..."
echo "----"

for f in /scripts/*.curl.sh
do 
    echo $f
    sh $f
done
if [ $? -eq 0 ]
then
    echo "DONE."
else
    echo "FAILED."
fi
unset APISIX_ADMIN_KEY