#! /bin/bash

# ------------------------------------------------------------------
# Utilitary functions and common options shared by the scripts.
# - Display methods: info, warn, etc
# - intialization methods.
# ------------------------------------------------------------------


# Flags
[ -z "$VERBOSE_FLAG" ] &&  export VERBOSE_FLAG=0
[ -z "$QUIET_FLAG" ] &&  export QUIET_FLAG=0
[ -z "$HELP_FLAG" ] &&  export HELP_FLAG=0
[ -z "$COMMONS_INITIALIZED_FLAG" ] &&  export COMMONS_INITIALIZED_FLAG=0

# This string will contains the help message for the target script
USAGE_STRING=""

# Display functions - info, warning error and verbose messages (3 verbosity levels)
function info(){
[ $QUIET_FLAG -eq 0 ] && echo "[INFO] $*"
}

function warn(){
 echo "[WARNING] $*"
}

function verbose (){
    [ $VERBOSE_FLAG -ge 1 ] && echo "[VERBOSE] $*"
}

function vverbose (){
    [ $VERBOSE_FLAG -ge 2 ] && echo "[VERBOSE:2] $*"
}

function vvverbose (){
    [ $VERBOSE_FLAG -ge 3 ] && echo "[VERBOSE:3] $*"
}

function err (){
    >&2 echo "[ERROR] $*"
    exit 1
}

# Used to initialize the common parts of help string.
function init_help(){
    USAGE_STRING="\n $1 [ -v[v[v]] | --[v[v]]verbose ] [ -q | --quiet ] [ -h | --help ] $2\n\n"
}

# Initialization for the common options: help, verbose, etc.
function init_commons(){

    if [ "$COMMONS_INITIALIZED_FLAG" = "0" ]
    then

        local args=$*

        for arg in $args
        do

            case $arg in
                "--help" | "-h" | "-?")
                    HELP_FLAG=1
                    [ -n "$USAGE_STRING" ] && { echo -ne $USAGE_STRING; exit 0; }
                ;;
                 "--quiet" | "-q")
                    QUIET_FLAG=1

                ;;
                 "--verbose" | "-v")
                    VERBOSE_FLAG=$VERBOSE_FLAG+1
                ;;
                 "--vverbose" | "-vv")
                    VERBOSE_FLAG=2
                ;;
                 "--vvverbose" | "-vvv")
                    VERBOSE_FLAG=3
                ;;

            esac

        done;
        vverbose 'init_commons executed (first call)'
        export COMMONS_INITIALIZED_FLAG=1
    else  
        vvverbose 'init_commons already executed (skipping)'
    fi
}

# Copy the files from a root directory to a project respection the directory structure.
function install_overlay {
    local overlay_root=$1
    [ -z "$overlay_root" ] && err "the overlay directory parameter is required"
    [ -e $overlay_root ] || err "overlay directory not found: $overlay_root"
    [ -d $overlay_root ] || err "not a directory: $overlay_root"
    [ -r $overlay_root ] || err "not a readable directory: $overlay_root"
}
