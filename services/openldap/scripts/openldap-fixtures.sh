#!/usr/bin/env bash

#--------------------------------------#
# Fixtures script for Openldap         #
#                                      #  
# Creates an LDIF file for a test set  #
#--------------------------------------#


# Initialization
OPENLDAP_SCRIPT_DIR=`dirname $0`
. $OPENLDAP_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`" "[-f | --force] [-s | --size nbFixtures] [-o | --out filename]"
init_commons $*

: "${FIXTURES_SEED:=25476527}"
RANDOM=$FIXTURES_SEED
. $OPENLDAP_SCRIPT_DIR/openldap-env.sh $OPENLDAP_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $OPENLDAP_SCRIPT_DIR/openldap-env.sh"

# Sources for first names and last names:
# - https://www.data.gouv.fr/datasets/liste-de-prenoms-et-patronymes
# - https://www.data.gouv.fr/datasets/prenoms-declares
DOMAIN=avenirs-esr.fr
ETAB_FAKE_DOMAIN=etab.fr
FIXTURES_DATA_DIR=$OPENLDAP_SCRIPT_DIR/fixtures-data
FIRST_NAMES_FILE=$FIXTURES_DATA_DIR/liste_des_prenoms.csv
LAST_NAMES_FILE=$FIXTURES_DATA_DIR/patronymes.csv
BIRTH_DATES_FILE=$FIXTURES_DATA_DIR/birth-dates.csv
CURSUS_YEARS_FILE=$FIXTURES_DATA_DIR/cursus-years.csv
ASSIGNMENTS_FILE=$FIXTURES_DATA_DIR/assignments.csv
DEGREES_FILE=$FIXTURES_DATA_DIR/degrees.csv
DISCIPLINES_FILE=$FIXTURES_DATA_DIR/academic_displines.csv
STEPS_FILE=$FIXTURES_DATA_DIR/steps.csv
TEMPLATE=$FIXTURES_DATA_DIR/supann-template.ldif
TMP=$FIXTURES_DATA_DIR/fixture-buffer.tmp.nogit.ldif
TMP_FILE=""

CLEANED_TEMPLATE="${TEMPLATE%.ldif}-cleaned.nogit.tmp.ldif"
OUT=$LDIF_CUSTOM_DIR/100-openldap-fixtures.ldif
OBJECT_CLASSES_TO_DEL="sambaSamAccount utvpersonne posixAccount shadowAccount"
OBJECT_CLASSES_TO_KEEP="top organizationalUnit person organizationalPerson inetOrgPerson supannPerson eduPerson eduMember"
ATTRIBUTES_TO_KEEP="objectClass \
uid \
userPassword \
cn \
givenName \
displayName \
supannEtuId \
mail \
eduPersonPrimaryAffiliation \
sn \
supannEtablissement \
supannCivilite \
supannOIDCDateDeNaissance \
supannEntiteAffectation \
supannEntiteAffectationPrincipale \
eduPersonPrincipalName \
supannEtuSecteurDisciplinaire \
supannEtuDiplome \
supannEtuTypeDiplome \
supannEtuEtape \
supannAffectation \
supannEtuCursusAnnee \
supannNomDeNaissance \
eduPersonAffiliation \
supannCodeINE"

declare -i SUPANN_ETU_ID_START=$((10000000 + (RANDOM % 10000000)))
declare -i NB_ENTRIES=100
declare -i NB_UID_RETRIES=50
declare -i entry_count=1
declare -a FIRST_NAMES
declare -a LAST_NAMES
declare -a CIVILITIES
declare -a BIRTH_DATES
declare -a CURSUS_YEARS
declare -a ENTITY_CODES
declare -a ENTITY_LABELS
declare -a DEGREES
declare -a DISCIPLINES
declare -a DEGREE_TYPES
declare -a STEPS
UAI="0123456G"

declare  -i FORCE_FLAG=0
declare  -i OUT_FETCH_FLAG=0
declare  -i SIZE_FETCH_FLAG=0
function parse_options(){
    
    for arg in $REMAINING_ARGS
    do
    case $arg in
        "--force" | "-f")
            [ $OUT_FETCH_FLAG -ne 1 ] || err "Output file required with --out|-o option"
            FORCE_FLAG=1
        ;;

         "--size" | "-s")
            SIZE_FETCH_FLAG=1
        ;;
    
        "--out" | "-o")
            OUT_FETCH_FLAG=1
        ;;
       
        *)
            local -i invalid=1
            [ $OUT_FETCH_FLAG -eq 1 ] \
                && { OUT=$arg; OUT_FETCH_FLAG=0; invalid=0; }
            
            [ $SIZE_FETCH_FLAG -eq 1 ] \
                && { NB_ENTRIES=$arg; SIZE_FETCH_FLAG=0; invalid=0; }
            

            [ $invalid -eq 0 ] || invalid_arg $arg
        ;;
    esac
done
}


function check_file(){
    local file=$1
    [ -n "$file" ] || err "File path is empty"
    [ -f "$file" ] || err "File not found: $file"
    [ -r "$file" ] || err "File not readable: $file"
}

function check_files(){
    [ -e $OUT -a $FORCE_FLAG -ne 1 ] && err "File $OUT exists. Use --force|-f option to overwrite"
    check_file "$TEMPLATE"
    check_file "$FIRST_NAMES_FILE"
    check_file "$LAST_NAMES_FILE"
    check_file "$BIRTH_DATES_FILE"
    check_file "$CURSUS_YEARS_FILE"
    check_file "$ASSIGNMENTS_FILE"
    check_file "$DEGREES_FILE"
    check_file "$DISCIPLINES_FILE"
    check_file "$STEPS_FILE"
}

function create_cleaned_template(){
    cat "$TEMPLATE" > "$CLEANED_TEMPLATE" && verbose "File created: $CLEANED_TEMPLATE" || err "Unable to generate $CLEANED_TEMPLATE from $TEMPLATE"
    remove_object_classes
    remove_attributes
}

function create_out(){
    vverbose "create_out started"
    dir=`dirname $OUT`
    touch $dir || { info "The owner and group of $dir need to be $USER:$GROUP"; sudo chown -R $USER:$GROUP $dir; sudo chmod -R 755 $dir; }
    touch $dir || err "Unable to reset owner and group of $dir"
    : > "$OUT" || err "Unable to write to $OUT"
    cat >> "$OUT" <<'LDIF' || err "Unable to write to $OUT"
dn: ou=people,dc=ldap-dev,dc=avenirs-esr,dc=fr
objectClass: organizationalUnit
objectClass: top
ou: people
description: People branch

LDIF
    vverbose "branch people created"
}
    vverbose "create_out completed"

function remove_object_classes(){
    vverbose "remove_object_classes started".
    [ -f "$CLEANED_TEMPLATE" ] || err "Input file not found: $CLEANED_TEMPLATE"
    [ -n "$OBJECT_CLASSES_TO_KEEP" ] || { verbose "No objectClass to keep"; return 0; }
    vvverbose "remove_object_classes Object classes to keep: $OBJECT_CLASSES_TO_KEEP".

    awk -v keep="$OBJECT_CLASSES_TO_KEEP" '
        BEGIN {
            n = split(keep, a, /[[:space:]]+/)
            for (i = 1; i <= n; i++) {
                if (a[i] != "") m[tolower(a[i])] = 1
            }
        }
        {
            l = $0
            ll = tolower(l)
            if (ll ~ /^objectclass:[[:space:]]*/) {
                oc = ll
                sub(/^objectclass:[[:space:]]*/, "", oc)
                sub(/[[:space:]]*$/, "", oc)
                if (m[oc] != 1) next
            }
            print
        }
    ' "$CLEANED_TEMPLATE" > "$TMP" || err "Unable to write to $TMP"

    mv -f "$TMP" "$CLEANED_TEMPLATE" || err "Unable to update $CLEANED_TEMPLATE"
    vverbose "remove_object_classes completed"
}

function remove_attributes(){
    vverbose "remove_attributes started".
    [ -f "$CLEANED_TEMPLATE" ] || err "Input file not found: $CLEANED_TEMPLATE"
    [ -n "$ATTRIBUTES_TO_KEEP" ] || { verbose "No attribute to keep"; return 0; }
    vvverbose "remove_attributes Attributes to keep: $ATTRIBUTES_TO_KEEP".

    awk -v keep="$ATTRIBUTES_TO_KEEP" '
        BEGIN {
            n = split(keep, a, /[[:space:]]+/)
            for (i = 1; i <= n; i++) {
                if (a[i] != "") m[tolower(a[i])] = 1
            }
            drop_cont = 0
        }
        {
            line = $0
            if (line ~ /^ /) {
                if (drop_cont == 1) next
                print
                next
            }

            drop_cont = 0

            if (line ~ /^__ENTITY_ASSIGNMENTS__$/) {
                print
                next
            }

            if (line ~ /^dn:[[:space:]]*/) {
                print
                next
            }

            if (line ~ /^[[:space:]]*$/) {
                print
                next
            }

            attr = line
            sub(/:.*/, "", attr)
            al = tolower(attr)

            if (m[al] == 1) {
                print
                next
            }

            drop_cont = 1
            next
        }
    ' "$CLEANED_TEMPLATE" > "$TMP" || err "Unable to write to $TMP"

    mv -f "$TMP" "$CLEANED_TEMPLATE" || err "Unable to update $CLEANED_TEMPLATE"
    vverbose "remove_attributes completed"
}

function load_and_check_data_files(){
    info "Loading data files"
    check_files
    [ -n "$TMP_FILE" ] && rm -f "$TMP_FILE" || true
    TMP_FILE="$(mktemp)" || err "Unable to create temp file"
    
    FIRST_NAMES=()
    CIVILITIES=()
    BIRTH_DATES=()
    CURSUS_YEARS=()
    ENTITY_CODES=()
    ENTITY_LABELS=()
    DEGREES=()
    DISCIPLINES=()
    DEGREE_TYPES=()
    STEPS=()
    while IFS= read -r line; do
        [ -n "$line" ] || continue
        IFS=';' read -r g n <<< "$line"
        [ -n "$g" ] || continue
        [ -n "$n" ] || continue
        case "${g^^}" in
            F) CIVILITIES+=("MME") ;;
            M) CIVILITIES+=("M.") ;;
            *) continue ;;
        esac
        FIRST_NAMES+=("$n")
    done < "$FIRST_NAMES_FILE"

    mapfile -t BIRTH_DATES < <(awk 'NF' "$BIRTH_DATES_FILE")
    mapfile -t CURSUS_YEARS < <(awk 'NF' "$CURSUS_YEARS_FILE")
    
    while IFS= read -r line; do
        [ -n "$line" ] || continue
        IFS=';' read -r code label <<< "$line"
        [ -n "$code" ] || continue
        [ -n "$label" ] || continue
        ENTITY_CODES+=("$code")
        ENTITY_LABELS+=("$label")
    done < "$ASSIGNMENTS_FILE"
    
    while IFS= read -r line; do
        [ -n "$line" ] || continue
        IFS=';' read -r degree degree_type <<< "$line"
        [ -n "$degree" ] || continue
        [ -n "$degree_type" ] || continue
        DEGREES+=("$degree")
        DEGREE_TYPES+=("$degree_type")
    done < "$DEGREES_FILE"
    mapfile -t DISCIPLINES < <(awk 'NF' "$DISCIPLINES_FILE")
    mapfile -t STEPS < <(awk 'NF' "$STEPS_FILE")
    mapfile -t LAST_NAMES < <(awk 'NF' "$LAST_NAMES_FILE")
    [ ${#FIRST_NAMES[@]} -gt 0 ] || err "Unable to select a name from $FIRST_NAMES_FILE"
    [ ${#LAST_NAMES[@]} -gt 0 ] || err "Unable to select a name from $LAST_NAMES_FILE"
    [ ${#BIRTH_DATES[@]} -gt 0 ] || err "Unable to select a birth date from $BIRTH_DATES_FILE"
    [ ${#CURSUS_YEARS[@]} -gt 0 ] || err "Unable to select a cursus year from $CURSUS_YEARS_FILE"
    [ ${#ENTITY_CODES[@]} -gt 0 ] || err "Unable to select an entity from $ASSIGNMENTS_FILE"
    [ ${#ENTITY_LABELS[@]} -gt 0 ] || err "Unable to select an affectation from $ASSIGNMENTS_FILE"
    [ ${#DEGREES[@]} -gt 0 ] || err "Unable to select a degree from $DEGREES_FILE"
    [ ${#DISCIPLINES[@]} -gt 0 ] || err "Unable to select a discipline from $DISCIPLINES_FILE"
    [ ${#DEGREE_TYPES[@]} -gt 0 ] || err "Unable to select a degree type from $DEGREES_FILE"
    [ ${#DEGREES[@]} -eq ${#DEGREE_TYPES[@]} ] || err "Degrees and degree types count mismatch in $DEGREES_FILE (${#DEGREES[@]} vs ${#DEGREE_TYPES[@]})"
    [ ${#STEPS[@]} -gt 0 ] || err "Unable to select a step from $STEPS_FILE"
    info "Data files loaded"
}

function init(){
    info "Initialization started"
    load_and_check_data_files
    create_cleaned_template
    create_out
    entry_count=1
    info "Initialization completed"
    
}

function dispose(){
    [ -n "$TMP_FILE" ] && rm -f "$TMP_FILE" || true
    TMP_FILE=""
}

function generate_uid(){
    local last_name="$1"
    local cleaned_last_name="${last_name//[^[:alnum:]]/}"
    local base="${cleaned_last_name,,}"
    local -i i=0

    base="${base:0:8}"
    [ -n "$base" ] || err "Unable to generate uid from empty last_name"

    if ! grep -Fqx "uid: $base" "$OUT" 2>/dev/null; then
        echo "$base"
        return 0
    fi

    local -i existing=0
    existing=$(grep -E -c "^uid: ${base}[0-9]*$" "$OUT" 2>/dev/null)
    local -i suffix=$((existing + 1))

    while [ $i -lt $NB_UID_RETRIES ]; do
        local uid="${base}${suffix}"

        if ! grep -Fqx "uid: $uid" "$OUT" 2>/dev/null; then
            echo "$uid"
            return 0
        fi

        suffix=$((suffix + 1))
        i=$((i + 1))
    done

    err "Unable to generate unique uid after $NB_UID_RETRIES retries (base uid: $base)"
}

function fetch_cursus_year(){
    local birth_date="$1"
    local -i year_idx=0
    local -i allow_doctorate=0
    local -i current_year=0
    local -i birth_year=0

    if [ -z "$birth_date" ]; then
        allow_doctorate=1
    else
        current_year=$(date +%Y)
        birth_year=${birth_date:0:4}
        if [[ "$birth_year" =~ ^[0-9]{4}$ ]]; then
            if [ $((current_year - birth_year)) -gt 23 ]; then
                allow_doctorate=1
            fi
        fi
    fi

    if [ $allow_doctorate -eq 1 ]; then
        year_idx=$((RANDOM % ${#CURSUS_YEARS[@]}))
    else
        [ ${#CURSUS_YEARS[@]} -gt 1 ] || err "Unable to select a non-doctorate cursus year (CURSUS_YEARS has only 1 element)"
        year_idx=$((1 + (RANDOM % (${#CURSUS_YEARS[@]} - 1))))
    fi

    echo "${CURSUS_YEARS[year_idx]}"
}

function generate_entity_assignment_tmpfile(){
    local supannEntiteAffectationPrincipale=$1
    local -n out_assignments=$2
    out_assignments=()
    [ -n "$TMP_FILE" ] || err "Entity assignment temp file path is empty"
    : > "$TMP_FILE" || err "Unable to write temp file"

    local -i assignment_case=0
    assignment_case=$((RANDOM % 100))

    if [ $assignment_case -lt 80 ]; then
        out_assignments=("$supannEntiteAffectationPrincipale")
    elif [ $assignment_case -lt 90 ]; then
        out_assignments=("$supannEntiteAffectationPrincipale" "${ENTITY_CODES[RANDOM % ${#ENTITY_CODES[@]}]}")
    else
        [ ${#ENTITY_CODES[@]} -gt 1 ] || err "Unable to pick assignments excluding first entity (ENTITY_CODES must contain at least 2 values)"
        local -i n_assignments=0
        local -i i=0
        n_assignments=$((2 + (RANDOM % 2)))
        out_assignments=()
        while [ $i -lt $n_assignments ]; do
            out_assignments+=("${ENTITY_CODES[1 + (RANDOM % (${#ENTITY_CODES[@]} - 1))]}")
            i=$((i + 1))
        done
    fi

    declare -A seen_entities=()
    declare -a unique_supannEntiteAffectation=()
    local entity=""
    for entity in "${out_assignments[@]}"; do
        if [ -z "${seen_entities[$entity]+x}" ]; then
            seen_entities[$entity]=1
            unique_supannEntiteAffectation+=("$entity")
        fi
    done
    out_assignments=("${unique_supannEntiteAffectation[@]}")
    for entity in "${out_assignments[@]}"; do
        printf '%s\n' "supannEntiteAffectation: ${entity}" >> "$TMP_FILE" || err "Unable to write temp file"
    done
}

function generate_entry(){
    info "Generating entry $entry_count/$NB_ENTRIES"
    local first_name=""
    local last_name=""
    local civility=""
    local degree=""
    local discipline=""
    local degree_type=""
    local step=""
    local birth_date=""
    local supannAffectation=""
    local email=""
    local ine=$(printf "%010dB\n" "$entry_count") 
    local -i first_name_idx=0
    first_name_idx=$((RANDOM % ${#FIRST_NAMES[@]}))
    first_name="${FIRST_NAMES[first_name_idx]}"
    civility="${CIVILITIES[first_name_idx]}"
    last_name="${LAST_NAMES[RANDOM % ${#LAST_NAMES[@]}]}"
    birth_date="${BIRTH_DATES[RANDOM % ${#BIRTH_DATES[@]}]}"
    discipline="${DISCIPLINES[RANDOM % ${#DISCIPLINES[@]}]}"
    local -i degree_idx=0
    degree_idx=$((RANDOM % ${#DEGREES[@]}))
    degree="${DEGREES[degree_idx]}"
    degree_type="${DEGREE_TYPES[degree_idx]}"
    degree_type="${degree_type#\{SISE\}}"
    step="${STEPS[RANDOM % ${#STEPS[@]}]}"
    first_name="${first_name^^}"
    last_name="${last_name^^}"
    mail="$uid@$ETAB_FAKE_DOMAIN"
    display_name="$last_name $first_name"
    uid="$(generate_uid "$last_name")"
    eppn="$uid@$DOMAIN"
    cursus_year="$(fetch_cursus_year "$birth_date")"
    supann_etu_id=$((SUPANN_ETU_ID_START + entry_count))
    local -i assignment_idx=0
    assignment_idx=$((RANDOM % ${#ENTITY_CODES[@]}))
    supannEntiteAffectationPrincipale="${ENTITY_CODES[assignment_idx]}"
    supannAffectation="${ENTITY_LABELS[assignment_idx]}"
    declare -a supannEntiteAffectation=()
    local supannEntiteAffectationTmpFile=""
    generate_entity_assignment_tmpfile "$supannEntiteAffectationPrincipale" supannEntiteAffectation || err "Unable to create entity assignment temp file"
    supannEntiteAffectationTmpFile="$TMP_FILE"
    [ -n "$supannEntiteAffectationTmpFile" ] || err "Entity assignment temp file path is empty"
    [ -f "$supannEntiteAffectationTmpFile" ] || err "Entity assignment temp file not found: $supannEntiteAffectationTmpFile"
    [ -r "$supannEntiteAffectationTmpFile" ] || err "Entity assignment temp file not readable: $supannEntiteAffectationTmpFile"
    local supannAffectationEscaped=""
    supannAffectationEscaped="$(printf '%s' "$supannAffectation" | sed -e 's/\\/\\\\/g' -e 's/&/\\&/g' -e 's/|/\\|/g')"

    vverbose "entry_count: $entry_count"
    vverbose "UAI: $UAI"
    vverbose "uid: $uid"
    vverbose "INE: $ine"
    vverbose "mail: $mail"
    vverbose "EPPN: $eppn"
    vverbose "Civility: $civility"
    vverbose "First name: $first_name"
    vverbose "Last name: $last_name"
    vverbose "Display name: $display_name"
    vverbose "SupannEtuId: $supann_etu_id"
    vverbose "EMail: $email"
    vverbose "Birth date: $birth_date"
    vverbose "Cursus year: $cursus_year"
    vverbose "Discipline: $discipline"
    vverbose "Degree: $degree"
    vverbose "Degree type: $degree_type"
    vverbose "Step: $step"
    vverbose "SupannEntiteAffectationPrincipale: $supannEntiteAffectationPrincipale"
    vverbose "SupannEntiteAffectation: ${supannEntiteAffectation[*]}"
    cat $CLEANED_TEMPLATE \
        | sed s"/__UID__/$uid/g" \
        | sed s"/__INE__/$ine/g" \
        | sed s"/__EPPN__/$eppn/g" \
        | sed s"/__FIRST_NAME__/$first_name/g" \
        | sed s"/__LAST_NAME__/$last_name/g" \
        | sed s"/__DISPLAY_NAME__/$display_name/g" \
        | sed s"/__SUPANN_ETU_ID__/$supann_etu_id/g" \
        | sed s"/__MAIL__/$mail/g" \
        | sed s"/__UAI__/$UAI/g" \
        | sed s"/__CIVILITY__/$civility/g" \
        | sed s"/__BIRTH_DATE__/$birth_date/g" \
        | sed s"/__CURSUS_YEAR__/$cursus_year/g" \
        | sed s"/__DISCIPLINE__/$discipline/g" \
        | sed s"/__DEGREE__/$degree/g" \
        | sed s"/__DEGREE_TYPE__/$degree_type/g" \
        | sed s"/__STEP__/$step/g" \
        | sed s"%__USER_PASSWORD__%$AVENIRS_LDAP_FIXTURES_PASSWORD%g" \
        | sed "s|__MAIN_ENTITY_ASSIGNMENT_LABEL__|$supannAffectationEscaped|g" \
        | sed "s|__MAIN_ENTITY_ASSIGNMENT__|$supannEntiteAffectationPrincipale|g" \
        | sed "/^__ENTITY_ASSIGNMENTS__$/r $supannEntiteAffectationTmpFile" \
        | sed "/^__ENTITY_ASSIGNMENTS__$/d" \
        >>$OUT || err "Unable to write to $OUT"

    vverbose "----" 
}

function generate_entries() {
    while [ $entry_count -le $NB_ENTRIES ]; do
        generate_entry
        entry_count=$entry_count+1
    done
}

function generate_fixtures() {
    info "Fixtures generation started"
    
    parse_options "$*"
    init
    generate_entries
    echo "" >> $OUT
    dispose
    info "Fixtures file: $OUT"
    info "Fixtures generation completed"
}


 generate_fixtures $*