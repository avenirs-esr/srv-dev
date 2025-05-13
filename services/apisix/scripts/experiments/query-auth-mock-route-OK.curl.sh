AT="AT-1-a29sDr2iCnLiog-RRDVpuBII5cd4WD8r"

END_POINT="localhost/apim/auth-mock-test"

[ "$1" = "-d" -o "$1" = "--srv-dev" ] \
&& { END_POINT="http://srv-dev-avenir.srv-avenir.brgm.recia.net/apim/auth-mock-test"; shift; } 
echo -ne "\nUsing end point: $END_POINT\n\n"


curl  -X GET  "$END_POINT" -i


curl --header "Authorization: Bearer $AT" "$END_POINT?method=get&uri=/foo&resource=1" -i


echo -ne "\n\n"