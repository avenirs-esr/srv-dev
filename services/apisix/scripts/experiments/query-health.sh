END_POINT="http://localhost/node-api/health"

[ "$1" = "-d" -o "$1" = "--srv-dev" ] \
&& { END_POINT="http://srv-dev-avenir.srv-avenir.brgm.recia.net/node-api/health"; shift; } 
echo -ne "\nUsing end point: $END_POINT\n\n"


curl  -X GET  "$END_POINT" -i

echo -ne "\n\n"