#! /bin/sh

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
    $f
done
if [ $? -eq 0 ]
then
    echo "DONE."
else
    echo "FAILED."
fi