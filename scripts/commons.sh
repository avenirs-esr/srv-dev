#! /bin/bash

declare -i VERBOSE_FLAG=0
declare -i QUIET_FLAG=0
declare -i HELP_FLAG=0
USAGE_STRING=""


# [ "$1" = '-v' -o "$1" = '--verbose' -o "$2" = '-v' -o "$2" = '--verbose'  ] && VERBOSE_FLAG=1
# [ "$1" = '-q' -o "$1" = '--quiet' -o "$2" = '-q' -o "$2" = '--quiet'  ] && INFO_FLAG=0
# [ "$1" = "-h" -o "$1" = "--help" ] && { echo -ne "\n `basename $0` [ -v | --verbose ] [ -q | --quiet ]\n\n"; exit 0; }

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

function init_help(){
    USAGE_STRING="\n $1 [ -v[v[v]] | --[v[v]]verbose ] [ -q | --quiet ] [ -h | --help ] $2\n\n"
}

function init_commons(){
    
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
}
