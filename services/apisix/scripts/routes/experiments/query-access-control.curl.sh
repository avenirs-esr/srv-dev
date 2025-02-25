[ -z "$AT" ] && { echo "Error Token should be set in env variable AT (use \". query-login.sh\")"; exit 1; }


END_POINT="http://localhost/avenirs-portfolio-security/access-control"

[ "$1" = "-d" -o "$1" = "--srv-dev" ] \
&& { END_POINT="http://srv-dev-avenir.srv-avenir.brgm.recia.net/avenirs-portfolio-security/access-control"; shift; } 
echo -ne "\nUsing end point: $END_POINT\n\n"


curl  -X GET  "$END_POINT" -i


curl --header "x-authorization: $AT" "$END_POINT?method=get&uri=/foo&resource=1" -i


echo -ne "\n\n"