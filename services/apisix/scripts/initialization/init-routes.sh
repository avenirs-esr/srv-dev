#! /bin/sh

ROUTES_INIT_SCRIPT_DIR=$1


if [ -f "/scripts/secret_env" ]; then
    . /scripts/secret_env
elif [ -f "$ROUTES_INIT_SCRIPT_DIR/../../secret_env" ]; then
    . $ROUTES_INIT_SCRIPT_DIR/../../secret_env
else
    echo "ERROR: secret_env file not found." >&2
    echo "This file is not versioned download it from vaultwarden or use secret_env.sample to create it." >&2
    exit 1
fi
export APISIX_ADMIN_KEY=$APISIX_ADMIN_KEY

echo "----"
date
echo "APISIX Routes initialization started."
echo "----"
echo "Waiting for APISIX to be ready, sleeping for 30 seconds..."
sleep 30
echo "----"
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