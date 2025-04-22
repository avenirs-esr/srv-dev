

[ -z "$AT" ] && { echo "Error Token should be set in env variable AT (use \". query-login.sh\")"; exit 1; }

END_POINT="https://avenirs-apache/cas/oidc/profile?token=$AT"

[ "$1" = "-d" -o "$1" = "--srv-dev" ] \
&& { END_POINT="http://srv-dev-avenir.srv-avenir.brgm.recia.net/cas/oidc/profile?token=$AT"; shift; } 


echo -ne "\nUsing end point: $END_POINT\n\n"



curl -k -X GET  "$END_POINT" -i
echo -ne "\n\n"