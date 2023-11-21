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

# Constants to format the outputs.
BOLD='\033[1;30m'
RED='\033[0;31m'
BOLD_RED='\033[1;31m'
GREEN='\033[0;32m'
BOLD_GREEN='\033[1;32m'
PURPLE='\033[0;35m'
BOLD_PURPLE='\033[1;35m'
GREY='\033[0;30m'
BOLD_GREY='\033[1;30m'
YELLOW='\033[0;33m'
BOLD_YELLOW='\033[1;33m'
NC='\033[0m'

# This string will contains the help message for the target script
USAGE_STRING=""

# Display functions - info, warning error and verbose messages (3 verbosity levels)
function info(){
[ $QUIET_FLAG -eq 0 ] && echo -ne "${GREY}[${GREEN}INFO${GREY}]${NC} $*\n"
}

function warn(){
 echo -ne "${GREY}[${BOLD_PURPLE}WARNING${GREY}]${NC} $*\n"
}

function verbose (){
    [ $VERBOSE_FLAG -ge 1 ] && echo -ne "${GREY}[${YELLOW}VERBOSE:1${GREY}]${NC} $*\n"
}

function vverbose (){
    [ $VERBOSE_FLAG -ge 2 ] && echo -ne "${GREY}[${YELLOW}VERBOSE:2${GREY}]${NC} $*\n"
}

function vvverbose (){
    [ $VERBOSE_FLAG -ge 3 ] && echo -ne "${GREY}[${YELLOW}VERBOSE:3${GREY}]${NC} $*\n"
}

function err (){
    >&2 echo -ne "${GREY}[${BOLD_RED}ERROR${GREY}]${BOLD_RED} $*${NC}\n";
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
                    VERBOSE_FLAG=$[VERBOSE_FLAG+1]
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

# Copy the files from a root directory to a project with the same the directory structure.
function install_overlay {
   
    local overlay_root=$1
    local target=$2
    [ -z "$overlay_root" ] && err "the overlay directory parameter is required"
    [ -e $overlay_root ] || err "overlay directory not found: $overlay_root"
    [ -d $overlay_root ] || err "not a directory: $overlay_root"
    [ -r $overlay_root ] || err "not a readable directory: $overlay_root"

    [ -z "$target" ] && err "the target directory parameter is required"
    [ -e $target ] || err "target directory not found: $target"
    [ -d $target ] || err "not a directory: $target"
    [ -w $overlay_root ] || err "not a writable directory: $target"

    verbose "Processing overlay"
    local -i files_cpt=0
    local -i dir_cpt=0
    for  f in `ls -A $overlay_root`
    do
        local source=$overlay_root/$f
        [ -f $source ] &&  cp $source $target && { files_cpt=$files_cpt+1; vverbose "Overlay file: $source -> $target"; }
        [ -d $source ] &&  cp -R $source $target &&  { dir_cpt=$dir_cpt+1; vverbose "Overlay directory: $source -> $target"; }
    done
     verbose "Overlay processed (Files: $files_cpt, Directories: $dir_cpt)"

}

# Revert the modifications.
function remove_overlay {
   
    local target=$1
    
    [ -z "$target" ] && err "the target directory parameter is required"
    [ -e $target ] || err "target directory not found: $target"
    [ -d $target ] || err "not a directory: $target"
    [ -w $overlay_root ] || err "not a writable directory: $target"

    verbose "Removing overlay from $target"
    cd $target && git status && cd -
    [ $? -eq 0 ] && info "Overlay removed from $target" || err "Unable to remove overlay from $target"
}
