END_POINT="http://localhost/node-api/access-token"
USER="user_0"
PASSWORD="user_0_pwd"



[ "$1" = "-d" -o "$1" = "--srv-dev" ] \
&& { END_POINT="http://srv-dev-avenir.srv-avenir.brgm.recia.net/node-api/access-token"; shift; } 




if [ "$1" = "-u" -o "$1" = "--user"  ] 
then
     shift
     [ -n "$1" ] && { USER=$1; shift; } || { echo "Missing user."; exit 1; }
     
fi

if [ "$1" = "-p" -o "$1" = "--password"  ] 
then
     shift
     [ -n "$1" ] && { PASSWORD=$1; shift; } || { echo "Missing password."; exit 1; }
     
fi

echo -ne "\nUsing end point: $END_POINT\n"
echo  "User: $USER"
echo -ne "Password: $PASSWORD\n\n"

AT=`curl -X POST "$END_POINT" \
     -H "Content-Type: application/json" \
     -d '{"login": "$USER", "password": "$PASSWORD"}'`

echo "Access Token: $AT"
echo "export \"AT=$AT\""
export "AT=$AT"

echo -ne "\n\n"