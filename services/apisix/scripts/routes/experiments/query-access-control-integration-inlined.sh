[ -z "$AT" ] && { echo "Error Token should be set in env variable AT (use \". query-login.sh\")"; exit 1; }

END_POINT="http://localhost/node-api/ac-inlined"

[ "$1" = "-d" -o "$1" = "--srv-dev" ] \
&& { END_POINT="http://srv-dev-avenir.srv-avenir.brgm.recia.net/node-api/ac-inlined"; shift; } 


echo -ne "\nUsing end point: $END_POINT\n\n"



curl --header "Authorization: Bearer $AT" -X GET  "$END_POINT?resource=1" -i
echo -ne "\n\n"