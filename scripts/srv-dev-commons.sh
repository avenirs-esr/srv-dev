#! /bin/bash

# ------------------------------------------------------------------
# Utilitary functions and common options shared by the scripts.
# - Display methods: info, warn, etc.
# - intialization methods.
# - helpers.          
# ------------------------------------------------------------------

# Arguments without the common ones: -h, -v, etc.
REMAINING_ARGS=""

# Services fetched from the arguments or by scanning the service directory.
SERVICES=""

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
    [ "$1" = "--no-exit" ] && local -i no_exit=1 || local -i no_exit=0
    >&2 echo -ne "${GREY}[${BOLD_RED}ERROR${GREY}]${BOLD_RED} $*${NC}\n";
    [ $no_exit -ne 1 ] && exit 1
}

function warn_and_wait(){
    local msg=$1
    local -i count=$2
    [ $count -gt 0  ] || count=4
    echo "count $count"
    warn "$msg"; 

    while [ $count -gt 0 ]
    do
        echo -ne "$count..."
        sleep 1; 
        count=$count-1
    done
    echo "0"
}

# Used to initialize the common parts of help string.
function init_help(){
    USAGE_STRING="\n Usage: $1 [-v[v[v]] | --[v[v]]verbose ] [-q | --quiet] [-h | --help] $2\n\n"
}

function invalid_arg(){
    err "Invalid Argument: $1\n\n$USAGE_STRING"
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
                *) 
                    REMAINING_ARGS="$REMAINING_ARGS$arg "
                ;;
            esac

        done;
        vverbose 'init_commons executed (first call)'
        export COMMONS_INITIALIZED_FLAG=1
    else  
        vvverbose 'init_commons already executed (skipping)'
    fi
}

# Copy the files from a root directory to a project respecting the directory structure.
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

# Reverts the modifications from a github sub module.
function remove_overlay {
   
    local target=$1
    
    [ -z "$target" ] && err "the target directory parameter is required"
    [ -e $target ] || err "target directory not found: $target"
    [ -d $target ] || err "not a directory: $target"
    

    verbose "Removing overlay from $target"
    cd $target && git stash -u && cd -
    [ $? -eq 0 ] && info "Overlay removed from $target" || err "Unable to remove overlay from $target"
}

# Fetches the services by scanning the user args or the 
# services' root directory.
function init_services() {

    [ "$COMMONS_INITIALIZED_FLAG" = "0" ] && err "init_commons should be executed before init_services."

    local -i fetch_service_flag=0
    local -i cpt=0
   
    # Fetches the services from the command line argumants.
    for arg in $REMAINING_ARGS
    do
        
        case $arg in
            "--service" | "-s")
               
                fetch_service_flag=1
            ;;
            *)
                # Fetches a service
                if [ $fetch_service_flag -eq 1 ]
                then
                    local service=`basename $arg`
                    vverbose "Required service to bootstrap: $service"
                    local service_path=$SERVICES_ROOT/$service
                    vverbose "Required service path: $service_path"
                    
                    # Checks that the directory corresponding to the service exists.
                    [ -d $service_path ] || err "Invalid service $service: directory not found $service_path"
                    SERVICES="$SERVICES$service "
                    cpt=$cpt+1
                else
                    invalid_arg $arg
                fi
            ;;
        esac
    done

    [ $cpt -gt 0 ] && vvverbose "Services found from arguments: $SERVICES"

    # Scans the services directory
    # the echo is to remove the \n it cuold be also done via the GNU option -z of sed
    [ -z "$SERVICES" ] && { cd $SERVICES_ROOT && SERVICES=$(echo `ls -d *`) \
        && cd - >/dev/null \
        || err "Unable to set the services"; }

    vverbose "Services: $SERVICES"
}

# Checks the docker network and create it if required.
# This is done in the boostrap script because if done 
# in the main docker-compose file, sometime docker try to 
# use it before is actually created.
function check_network(){
   
    [ -z "$AVENIRS_NETWORK" ] && err "AVENIRS_NETWORK unset (should be defined in srv-dev-env.sh)"
    vverbose "Using network $AVENIRS_NETWORK"

    docker network inspect $AVENIRS_NETWORK > /dev/null 2>&1
    if [ $? -eq 0 ]
    then 
        verbose "Network $AVENIRS_NETWORK found"
    else    
        verbose "Network $AVENIRS_NETWORK need to be created."
        docker network create "$AVENIRS_NETWORK" --driver bridge  \
            && info "Network $AVENIRS_NETWORK created" \
            || err "Unable to create network $AVENIRS_NETWORK"
    fi
}

function init_git_branch(){
    local repository_dir=$1
    local remote_branch=$2
    local local_branch=$3

    [ -n $repository_dir ] || err "init_git_branch: parameter repository_dir is required"
    [ -n $remote_branch ] || err "init_git_branch: parameter remote_branch is required"
    [ -n $local_branch ] || err "init_git_branch: parameter local_branch is required"

    cd $repository_dir || err "Unable to enter $repository_dir"
    
    if [ -z "`git branch   | grep $local_branch`" ]
    then
        verbose "Switching to branch $remote_branch (local branch $local_branch)"
        git checkout -B $local_branch $remote_branch || err "unable to create branch $local_branch from $remote_branch"
    else 
        verbose "Local branch found $local_branch"
    fi
    cd - >/dev/null
}


