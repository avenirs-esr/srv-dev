#!/usr/bin/env bash

OPENLDAP_SCRIPT_DIR=$(dirname "$0")
. "$OPENLDAP_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh"
init_help "$(basename "$0")" "<external-users.json>"
init_commons "$@"
. "$OPENLDAP_SCRIPT_DIR/openldap-env.sh" "$OPENLDAP_SCRIPT_DIR" 2>/dev/null || err "Unable to source openldap-env.sh"

JSON_PATH=""
PEOPLE_DN="ou=people,$LDAP_BASE_DN"
FIXTURES_DATA_DIR="$OPENLDAP_SCRIPT_DIR/fixtures-data"
FIRST_NAMES_FILE="$FIXTURES_DATA_DIR/liste_des_prenoms.csv"
TMP_DIR=""
HEADER_FILE=""
NEW_ENTRIES_FILE=""
OUTPUT_FILE=""
declare -a RECORD_FILES=()
declare -a JSON_ENTRIES=()
declare -A FIRST_NAME_GENDER=()
declare -A KNOWN_UIDS=()

function cleanup(){
    [ -n "$TMP_DIR" ] && [ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"
    [ -n "$NEW_ENTRIES_FILE" ] && rm -f "$NEW_ENTRIES_FILE"
    [ -n "$OUTPUT_FILE" ] && rm -f "$OUTPUT_FILE"
}
trap cleanup EXIT

function parse_args(){
    local parsed=0
    for arg in $REMAINING_ARGS; do
        if [ $parsed -eq 0 ]; then
            JSON_PATH="$arg"
            parsed=1
        else
            invalid_arg "$arg"
        fi
    done
    [ -n "$JSON_PATH" ] || err "JSON file path is required"
}

function ensure_tools(){
    command -v jq >/dev/null 2>&1 || err "jq is required"
}

function check_file(){
    local file=$1
    [ -f "$file" ] || err "File not found: $file"
    [ -r "$file" ] || err "File not readable: $file"
}

function load_gender_map(){
    while IFS=';' read -r gender name; do
        [ -n "$gender" ] || continue
        [ -n "$name" ] || continue
        FIRST_NAME_GENDER["${name^^}"]=$gender
    done < "$FIRST_NAMES_FILE"
}

function load_existing_uids(){
    while read -r value; do
        [ -n "$value" ] || continue
        KNOWN_UIDS["$value"]=1
    done < <(grep -E '^uid: ' "$LDIF_FILE" | awk '{print $2}')
}

function split_ldif(){
    TMP_DIR=$(mktemp -d) || err "Unable to create temp directory"
    HEADER_FILE="$TMP_DIR/header.ldif"
    awk -v header="$HEADER_FILE" -v dir="$TMP_DIR" '
        BEGIN{RS=""; ORS=""}
        NR==1 {print $0 "\n\n" > header; next}
        {file=sprintf("%s/entry-%05d.ldif", dir, NR-1); print $0 "\n\n" > file}
    ' "$LDIF_FILE"
    mapfile -t RECORD_FILES < <(find "$TMP_DIR" -maxdepth 1 -name 'entry-*.ldif' -print | sort)
}

function normalize_uid_base(){
    local value="$1"
    local ascii="$value"
    if command -v iconv >/dev/null 2>&1; then
        local converted
        converted=$(printf '%s' "$value" | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null)
        [ -n "$converted" ] && ascii="$converted"
    fi
    ascii=${ascii//[^[:alnum:]]/}
    ascii=${ascii,,}
    ascii=${ascii:0:8}
    [ -n "$ascii" ] || err "Unable to build uid base from $value"
    echo "$ascii"
}

function generate_uid(){
    local last_name="$1"
    local base
    base=$(normalize_uid_base "$last_name")
    local candidate="$base"
    local -i suffix=1
    while [ -n "${KNOWN_UIDS[$candidate]+x}" ]; do
        candidate="${base}${suffix}"
        suffix=$((suffix + 1))
        [ $suffix -le 1000 ] || err "Unable to generate uid for $last_name"
    done
    KNOWN_UIDS["$candidate"]=1
    echo "$candidate"
}

function guess_civility(){
    local name="$1"
    local gender="${FIRST_NAME_GENDER["${name^^}"]}"
    if [ "$gender" = "F" ]; then
        echo "MME"
    else
        echo "M."
    fi
}

function map_affiliation(){
    local category="${1^^}"
    case "$category" in
        STUDENT) echo "student" ;;
        TEACHER) echo "faculty" ;;
        *) echo "member" ;;
    esac
}

function build_entry(){
    local template_file="$1"
    local uid="$2"
    local first_name="$3"
    local last_name="$4"
    local mail="$5"
    local civility="$6"
    local affiliation="$7"
    local output_file="$8"
    local display="${last_name} ${first_name}"
    local dn="uid=$uid,$PEOPLE_DN"
    while IFS= read -r line || [ -n "$line" ]; do
        case "$line" in
            dn:*) line="dn: $dn" ;;
            uid:*) line="uid: $uid" ;;
            cn:*) line="cn: $display" ;;
            givenName:*) line="givenName: $first_name" ;;
            displayName:*) line="displayName: $display" ;;
            sn:*) line="sn: $last_name" ;;
            supannNomDeNaissance:*) line="supannNomDeNaissance: $last_name" ;;
            mail:*) line="mail: ${mail,,}" ;;
            eduPersonPrincipalName:*) line="eduPersonPrincipalName: ${mail,,}" ;;
            supannCivilite:*) line="supannCivilite: $civility" ;;
            eduPersonPrimaryAffiliation:*) line="eduPersonPrimaryAffiliation: $affiliation" ;;
            eduPersonAffiliation:*) line="eduPersonAffiliation: $affiliation" ;;
        esac
        printf "%s\n" "$line" >> "$output_file"
    done < "$template_file"
    printf "\n" >> "$output_file"
}

function load_json_entries(){
    mapfile -t JSON_ENTRIES < <(jq -c '.[]' "$JSON_PATH")
    [ ${#JSON_ENTRIES[@]} -gt 0 ] || err "No entries found in $JSON_PATH"
}

function prepare_new_entries(){
    NEW_ENTRIES_FILE=$(mktemp) || err "Unable to create temp file"
    local -i idx=0
    for entry in "${JSON_ENTRIES[@]}"; do
        [ $idx -lt ${#RECORD_FILES[@]} ] || err "Not enough template entries in $LDIF_FILE"
        local template_file="${RECORD_FILES[$idx]}"
        local first_name=$(jq -r '.firstName' <<<"$entry")
        local last_name=$(jq -r '.lastName' <<<"$entry")
        local email=$(jq -r '.email' <<<"$entry")
        local category=$(jq -r '.category' <<<"$entry")
        local uid
        uid=$(generate_uid "$last_name")
        local first_u="${first_name^^}"
        local last_u="${last_name^^}"
        local civility
        civility=$(guess_civility "$first_name")
        local affiliation
        affiliation=$(map_affiliation "$category")
        build_entry "$template_file" "$uid" "$first_u" "$last_u" "$email" "$civility" "$affiliation" "$NEW_ENTRIES_FILE"
        idx=$((idx + 1))
    done
}

function rebuild_ldif(){
    OUTPUT_FILE=$(mktemp) || err "Unable to create output file"
    cat "$HEADER_FILE" > "$OUTPUT_FILE"
    printf "\n" >> "$OUTPUT_FILE"
    cat "$NEW_ENTRIES_FILE" >> "$OUTPUT_FILE"
    local -i idx=${#JSON_ENTRIES[@]}
    while [ $idx -lt ${#RECORD_FILES[@]} ]; do
        cat "${RECORD_FILES[$idx]}" >> "$OUTPUT_FILE"
        idx=$((idx + 1))
    done
    mv "$OUTPUT_FILE" "$LDIF_FILE"
    OUTPUT_FILE=""
}

function main(){
    parse_args
    ensure_tools
    check_file "$JSON_PATH"
    check_file "$LDIF_FILE"
    check_file "$FIRST_NAMES_FILE"
    load_gender_map
    load_existing_uids
    split_ldif
    load_json_entries
    prepare_new_entries
    rebuild_ldif
    info "LDIF file aligned with $JSON_PATH"
}

main "$@"
