#! /bin/bash

# Generates an LDAP test set.


SCRIPT_DIR="`dirname $0`/../fixtures"
IN=$SCRIPT_DIR/openldap-data.csv
OUT=$SCRIPT_DIR/openldap-fixtures.ldif
TEMPLATE=$SCRIPT_DIR/openldap-template.ldif
BRANCHES=$SCRIPT_DIR/openldap-branches.ldif

USER_PASSWORD='{ssha}Ke8lVwbkuJcEbWdCur8XLG9QwggNciz6UlwH/w==' #Azerty123
OUT_FETCH_FLAG=0


. $SCRIPT_DIR/../../scripts/commons.sh
init_help "`basename $0`" "[ -o | --out filename ]"
init_commons $*
function generate() {
    info "LDIF generation started."
    info "Using file: $OUT."
    IFS=$'\n'
    cat $BRANCHES>$OUT
    for l in `cat $IN | grep "^[^#]"`
    do 
        parse "$l"
    
    done
    info "LDIF generation completed."
}

function parse() {
    local l=$1
    verbose "$l"
    uid=`echo $l | cut -f 1 -d ';'| sed s/^' '*//g | sed s/' *$'//g`
    entry=`echo $l | cut -f 2 -d ';'| sed s/^' '*//g | sed s/' *$'//g`
    givenName=${entry,,}
    givenNameCap=${entry^}
    entry=`echo $l | cut -f 3 -d ';'| sed s/^' '*//g | sed s/' *$'//g`
    sn=${entry^^}
    uidNumber=`echo $l | cut -f 4 -d ';'| sed s/^' '*//g | sed s/' *$'//g`
    gidNumber=`echo $l | cut -f 5 -d ';'| sed s/^' '*//g | sed s/' *$'//g`
    cn="$sn $givenNameCap"
    gecos=$cn
   generate_ldif $uid $cn $sn $givenName $gecos $uidNumber $gidNumber
}


function generate_ldif(){
    local uid=$1
    local cn=$2
    local sn=$3
    local givenName=$4
    local gecos=$5
    local uidNumber=$6
    local gidNumber=$7
    verbose "uid          $uid"
    verbose "givenName    $givenName"
    verbose "givenNameCap $givenNameCap"
    verbose "sn           $sn"
    verbose "cn           $cn"
    verbose "gecos        $gecos"
    verbose "uidNumber    $uidNumber"
    verbose "gidNumber    $gidNumber"
    cat $TEMPLATE \
        | sed s"/__UID__/$uid/g" \
        | sed s"/__CN__/$cn/g" \
        | sed s"/__SN__/$sn/g" \
        | sed s"/__GIVEN_NAME__/$givenName/g" \
        | sed s"/__GECOS__/$gecos/g" \
        | sed s"/__UID_NUMBER__/$uidNumber/g" \
        | sed s"/__GID_NUMBER__/$gidNumber/g"\
        | sed s"%__USER_PASSWORD__%$USER_PASSWORD%g">>$OUT || err "Unable to write to $OUT"
}


    
    
    
for arg in $*
do
    case $arg in
        "--out" | "-o")
            OUT_FETCH_FLAG=1
        ;;
        *)
            [ $OUT_FETCH_FLAG -eq 1 ] && { OUT=$arg; OUT_FETCH_FLAG=0; }
        ;;
    esac
done

touch $OUT 2>/dev/null || err "$OUT not writable"
generate