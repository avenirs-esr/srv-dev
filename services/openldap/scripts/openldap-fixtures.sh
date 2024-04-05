

#--------------------------------------#
# Fixtures script for Openldap         #
#                                      #  
# Creates an LDIF file for a test set  #
#--------------------------------------#


# Initialization
OPENLDAP_SCRIPT_DIR=`dirname $0`
. $OPENLDAP_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*
init_help "`basename $0`" "[ -o | --out filename ]"
. $OPENLDAP_SCRIPT_DIR/openldap-env.sh $OPENLDAP_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $OPENLDAP_SCRIPT_DIR/openldap-env.sh"




SCRIPT_DIR="$OPENLDAP_SCRIPT_DIR/../fixtures"
IN=$SCRIPT_DIR/openldap-data.csv
OUT=$SCRIPT_DIR/openldap-fixtures.ldif
TEMPLATE=$SCRIPT_DIR/openldap-template.ldif
BRANCHES=$SCRIPT_DIR/openldap-branches.ldif

# Flag to force fixture re-generation
OUT_FETCH_FLAG=0

# Flag to fetch the output file name
OUT_FETCH_FLAG=0

# Generates the ldif file
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
    vverbose "$l"
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
    local mail="$uid@univ.fr"
    vvverbose "uid          $uid"
    vvverbose "givenName    $givenName"
    vvverbose "givenNameCap $givenNameCap"
    vvverbose "sn           $sn"
    vvverbose "cn           $cn"
    vvverbose "mail        $mail"
    vvverbose "gecos        $gecos"
    vvverbose "uidNumber    $uidNumber"
    vvverbose "gidNumber    $gidNumber"

    cat $TEMPLATE \
        | sed s"/__UID__/$uid/g" \
        | sed s"/__CN__/$cn/g" \
        | sed s"/__SN__/$sn/g" \
        | sed s"/__GIVEN_NAME__/$givenName/g" \
        | sed s"/__GECOS__/$gecos/g" \
        | sed s"/__UID_NUMBER__/$uidNumber/g" \
        | sed s"/__GID_NUMBER__/$gidNumber/g"\
         | sed s"/__USER_MAIL__/$mail/g"\
        | sed s"%__USER_PASSWORD__%$AVENIRS_LDAP_FIXTURES_PASSWORD%g">>$OUT || err "Unable to write to $OUT"
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

# When the container has already been launched the owner:group of the file and directory
# is openldap:openldap (911:911).
# This is a workaround and should be handled via another mecanism, group mapping or instance.
touch $OUT 2>/dev/null || { 
    dir=`dirname $OUT`
    warn "Deleting $dir"
    sudo rm -Rf $dir || err "Unable to delete directory $dir (fixtures process)"
    mkdir $dir || err "Unable to create directory $dir (fixtures process)"
    touch $OUT || err "Unable to create file $OUT (fixtures process)"
    info "Fixtures directory reseted"
}

generate