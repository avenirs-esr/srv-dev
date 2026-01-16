#!/usr/bin/env bash

#--------------------------------------#
# Script to generate a json from data  #
# to test the feeding process.         #
#                                      #  
#--------------------------------------#


# Initialization
OPENLDAP_SCRIPT_DIR=`dirname $0`
. $OPENLDAP_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_help "`basename $0`" "[-f|--force] [-l|--limit nbResultRequested] [-s|--show-result] [-o | --out filename]"
init_commons $*

. $OPENLDAP_SCRIPT_DIR/openldap-env.sh $OPENLDAP_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $OPENLDAP_SCRIPT_DIR/openldap-env.sh"

DEFAULT_ATTRIBUTES="givenName,sn,mail,displayName,supannCivilite,supannCodeINE,\
supannEtablissement,supannEtuCursusAnnee,eduPersonAffiliation,supannEtuDiplome,\
supannEtuEtape,supannEtuTypeDiplome,supannOIDCDateDeNaissance"
LDAP_FILTER="${LDAP_FILTER:-(objectClass=inetOrgPerson)}"
LDAP_URL="${LDAP_URL:-ldap://localhost:389}"
LOGIN_DN="${LOGIN_DN:-cn=admin,dc=ldap-dev,dc=avenirs-esr,dc=fr}"
BASE_DN="${BASE_DN:-ou=people,dc=ldap-dev,dc=avenirs-esr,dc=fr}"
LIMIT="${LIMIT:-0}"
ATTRIBUTES="${ATTRIBUTES:-$DEFAULT_ATTRIBUTES}"

JSON_TEMPLATE="{
    \"metadata\": {
        \"size\": __SIZE__
    },
    \"entries\": [
    __ENTRIES__
    ]
}"

ENTRY_TEMPLATE="{
\"civility\": \"__supannCivilite__\",
    \"firstName\": \"__givenName__\",
    \"lastName\": \"__sn__\",
    \"displayName\": \"__displayName__\",
    \"audience\": \"__eduPersonAffiliation__\",
    \"INE\": \"__supannCodeINE__\",
    \"mail\": \"__mail__\",
    \"structure\": \"__supannEtablissement__\",
    \"cursusYear\": \"__supannEtuCursusAnnee__\",
    \"degree\": \"__supannEtuDiplome__\",
    \"degreeType\": \"__supannEtuTypeDiplome__\",
    \"step\": \"__supannEtuEtape__\",
    \"birthDate\": \"__supannOIDCDateDeNaissance__\"
}"

OUT=/tmp/students.json
declare -i FORCE_FLAG=0
declare -i SHOW_RESULT_FLAG=0
TMP_OUT_FILE=""
TMP_ERR_FILE=""
TMP_WORK_FILE=""
declare -i NB_ENTRIES=0;


function parse_options(){
    local -i fetch_out_flag=0
    local -i fetch_limit_flag=0
    
    for arg in $REMAINING_ARGS
    do
        case $arg in
            "--force" | "-f")
                [ $fetch_out_flag -ne 1 ] || err "Output file required with --out|-o option"
                [ $fetch_limit_flag -ne 1 ] || err "Limit required with --limit|-l option"
                FORCE_FLAG=1
            ;;

             "--show-result" | "-s")
                [ $fetch_out_flag -ne 1 ] || err "Output file required with --out|-o option"
                [ $fetch_limit_flag -ne 1 ] || err "Limit required with --limit|-l option"
                SHOW_RESULT_FLAG=1
            ;;

            
            "--out" | "-o")
                [ $fetch_limit_flag -ne 1 ] || err "Limit required with --limit|-l option"
                fetch_out_flag=1
            ;;

             "--limit" | "-l")
                [ $fetch_out_flag -ne 1 ] || err "Output file required with --out|-o option"
                fetch_limit_flag=1
            ;;

            *)
                local -i invalid=1
                [ $fetch_out_flag -eq 1 ] \
                    && { OUT=$arg; fetch_out_flag=0; invalid=0; }
                [ $fetch_limit_flag -eq 1 ] \
                    && { LIMIT=$arg; fetch_limit_flag=0; invalid=0; }

                
                [ $invalid -eq 0 ] || invalid_arg $arg
            ;;
        esac
    done
}



function init(){
    info "Initialization started"
    TMP_OUT_FILE=$(mktemp) || err "Unable to create tmp out file: $TMP_OUT_FILE"
    TMP_ERR_FILE=$(mktemp) || err "Unable to create tmp error file: $TMP_ERR_FILE"
    TMP_WORK_FILE=$(mktemp) || err "Unable to create tmp work file: $TMP_WORK_FILE"
    declare -i NB_ENTRIES=0;


    [ -e $OUT -a $FORCE_FLAG -ne 1 ] && err "File $OUT exists. Use --force|-f option to overwrite"
    [ -n "$BASE_DN" ] || err "BASE_DN is not set"
    [ -n "$LDAP_URL" ] || err "LDAP_URL is not set"
    [ -n "$LDAP_FILTER" ] || err "LDAP filter is empty"
    [ -n "$LOGIN_DN" ] || err "LOGIN_DN is not set"
    [ -n "$SEC_LDAP_ADMIN_PASSWORD" ] || err "SEC_LDAP_ADMIN_PASSWORD is not set (should be set in .secrets.env)"
    [ -n "$LIMIT" ] || err "LIMIT is not set"
    [ -n "$ATTRIBUTES" ] || err "ATTRIBUTES is not set"

    info "LDAP URL: $LDAP_URL"
    info "Login DN: $LOGIN_DN"
    info "Base DN: $BASE_DN"
    info "LDAP filter: $LDAP_FILTER"
    info "Attributes: $ATTRIBUTES"
    info "Limit: $LIMIT"

    info "Initialization completed"
    
}

function dispose(){
    info "Disposing resources"
    [ -n "$TMP_OUT_FILE" ] && rm -f "$TMP_OUT_FILE"
    [ -n "$TMP_ERR_FILE" ] && rm -f "$TMP_ERR_FILE"
    [ -n "$TMP_WORK_FILE" ] && rm -f "$TMP_WORK_FILE"
    info "Disposing completed"
}

function fetch_entries(){
    vverbose "Fetching entries from LDAP"

    local -a attrs_array
    IFS=',' read -r -a attrs_array <<< "$ATTRIBUTES"

    local entries
    
    LDAP_CMD="ldapsearch -LLL -o ldif-wrap=no -H \"$LDAP_URL\" -D \"$LOGIN_DN\" -w \"$SEC_LDAP_ADMIN_PASSWORD\" -b \"$BASE_DN\" -z \"$LIMIT\" \"$LDAP_FILTER\" \"${attrs_array[@]}\""

    ldapsearch -LLL -o ldif-wrap=no -H "$LDAP_URL" -D "$LOGIN_DN" -w "$SEC_LDAP_ADMIN_PASSWORD" -b "$BASE_DN" -z "$LIMIT" "$LDAP_FILTER" "${attrs_array[@]}" >"$TMP_OUT_FILE" 2>"$TMP_ERR_FILE"
    local -i ldap_rc=$?

    if [ $ldap_rc -ne 0 ] && [ $ldap_rc -ne 4 ]; then
        local ldap_err
        ldap_err=$(cat "$TMP_ERR_FILE")
        rm -f "$TMP_OUT_FILE" "$TMP_ERR_FILE"
        err --no-exit "ldapsearch failed: $ldap_err"
        err --no-exit "Search command:"
        err "$LDAP_CMD"
    fi
    vverbose "LDAP search command: $LDAP_CMD"


    if [ $ldap_rc -eq 4 ]; then
        local ldap_warn
        ldap_warn=$(cat "$TMP_ERR_FILE")
        [ -n "$ldap_warn" ] && vverbose "$ldap_warn"
    fi
}

function handle_base64_value(){
    local value="$1"
    printf '%s' "$value" | base64 -d
}

function escape_json_values(){
    local value="$1"
    value=${value//\\/\\\\}
    value=${value//"/\\"}
    value=${value//$'\n'/\\n}
    value=${value//$'\r'/\\r}
    value=${value//$'\t'/\\t}
    printf '%s' "$value"
}

function process_entry(){
    local entry="$1"

    local attribute=""
    local value=""
    local line=""
    local placeholder=""
    local entry_json="$ENTRY_TEMPLATE"
    ((NB_ENTRIES+=1))
    verbose "Processing entry $NB_ENTRIES"

    while IFS= read -r line || [ -n "$line" ]; do
        [ -n "$line" ] || continue

        if [[ "$line" == *":: "* ]]; then
            attribute="${line%%::*}"
            value="${line#*:: }"
            value="$(handle_base64_value "$value")"
        elif [[ "$line" == *": "* ]]; then
            attribute="${line%%:*}"
            value="${line#*: }"
        else
            continue
        fi

        value="$(escape_json_values "$value")"
        placeholder="__${attribute}__"
        entry_json="${entry_json//$placeholder/$value}"
        verbose "attribute: $attribute - value: $value"
    done <<< "$entry"
    vverbose Entry: "$entry_json"
    if [ $NB_ENTRIES -gt 1 ]; then
        printf ',\n' >> "$TMP_WORK_FILE"
    fi
    printf '%s' "$entry_json" >> "$TMP_WORK_FILE"
    verbose "----"
}

function process_entries(){
    vverbose "Processing entries"
    fetch_entries
    entries=$(cat "$TMP_OUT_FILE" 2>/dev/null) || err "Failed to read LDAP tmp output file $TMP_OUT_FILE"
    

    [ -n "$entries" ] || err "No entries returned"

    local entry_block=""
    while IFS= read -r line || [ -n "$line" ]; do
        if [ -z "$line" ]; then
            if [ -n "$entry_block" ]; then
                process_entry "$entry_block"
                entry_block=""
            fi
        else
            if [ -n "$entry_block" ]; then
                entry_block+=$'\n'
            fi
            entry_block+="$line"
        fi
    done <<< "$entries"$'\n'


    local entries_json
    entries_json=$(cat "$TMP_WORK_FILE" 2>/dev/null) || err "Failed to read LDAP tmp work file $TMP_WORK_FILE"
    local final_json
    final_json="${JSON_TEMPLATE/__SIZE__/$NB_ENTRIES}"
    final_json="${final_json/__ENTRIES__/$entries_json}"
    printf '%s\n' "$final_json" > "$OUT" || err "Unable to write output file $OUT"

    if command -v jq >/dev/null 2>&1; then
        local formatted_out
        formatted_out=$(mktemp) || err "Unable to create tmp file"
        jq . "$OUT" > "$formatted_out" 2>/dev/null || { rm -f "$formatted_out"; err "Invalid JSON generated"; }
        mv "$formatted_out" "$OUT" || err "Unable to finalize output file $OUT"
    fi
}

function show_result(){
    if [ $SHOW_RESULT_FLAG -eq 1 ]; then
        cat "$OUT"
    fi
}

function generate_json(){
    info "Generating JSON file"
    parse_options $*
    init

    process_entries

    dispose

    info "JSON File generate: $OUT"
    show_result
}   


generate_json $*



