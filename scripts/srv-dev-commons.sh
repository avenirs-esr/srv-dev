#! /bin/bash

# ------------------------------------------------------------------
# Utilitary functions and common options shared by the scripts.
# - Display methods: info, warn, etc.
# - intialization methods.
# - helpers.          
# ------------------------------------------------------------------

# Arguments without the common ones: -h, -v, etc.
[ -z "$REMAINING_ARGS" ] &&  export REMAINING_ARGS=""

# Services fetched from the arguments or by scanning the service directory.
SERVICES=""

# Flags
[ -z "$VERBOSE_FLAG" ] &&  export VERBOSE_FLAG=0
[ -z "$QUIET_FLAG" ] &&  export QUIET_FLAG=0
[ -z "$HELP_FLAG" ] &&  export HELP_FLAG=0
[ -z "$PURGE_FLAG" ] &&  export PURGE_FLAG=0
[ -z "$PURGE_FLAG_INITALIZED" ] &&  export PURGE_FLAG_INITALIZED=0
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
    return 0;
}

function vverbose (){
    [ $VERBOSE_FLAG -ge 2 ] && echo -ne "${GREY}[${YELLOW}VERBOSE:2${GREY}]${NC} $*\n"
    return 0;
}

function vvverbose (){
    [ $VERBOSE_FLAG -ge 3 ] && echo -ne "${GREY}[${YELLOW}VERBOSE:3${GREY}]${NC} $*\n"
    return 0;
}

function err (){
    [ "$1" = "--no-exit" ] && local -i no_exit=1 || local -i no_exit=0
    >&2 echo -ne "${GREY}[${BOLD_RED}ERROR${GREY}]${BOLD_RED} $*${NC}\n";
    [ $no_exit -ne 1 ] && exit 1
    return 0
}

function warn_and_wait(){
    local msg=$1
    local -i count=$2
    [ $count -gt 0  ] || count=4
    
    warn "$msg"; 

    while [ $count -gt 0 ]
    do
        echo -ne "$count..."
        sleep 1; 
        count=$count-1
    done
    echo "0"
    return 0
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
        vverbose "init_commons executed (first call)"
        vvverbose "init_commons REMAINING_ARGS: $REMAINING_ARGS"
        export COMMONS_INITIALIZED_FLAG=1
    else  
        vvverbose "init_commons already executed (skipping) RA $REMAINING_ARGS"
        vvverbose "init_commons REMAINING_ARGS: $REMAINING_ARGS"
    fi
}

# Initialization for the purge flag.
function init_purge_flag(){
    if [  $PURGE_FLAG_INITALIZED -eq 0 ]
    then
        PURGE_FLAG_INITALIZED=1;
        local updated_remaining_args=""
        for arg in $REMAINING_ARGS
        do
            if [ $arg = "-p" -o "$arg" = "--purge" ]
            then
                PURGE_FLAG=1
                warn "Purge required, the data directory will be deleted"
            else  
                 updated_remaining_args="$updated_remaining_args$arg " 
            fi
        done
        REMAINING_ARGS=$updated_remaining_args
    fi
}

# Copy the files from a root directory to a project respecting the directory structure.
# @param $1 Root directory of the overlay.
# @param $2 target, destination to copy the files.
function install_overlay {
   
    local overlay_root=$1
    local target=$2
    [ -z "$overlay_root" ] && err "the overlay directory parameter is required"
    [ -e $overlay_root ] || err "overlay directory not found: $overlay_root"
    [ -d $overlay_root ] || err "not a directory: $overlay_root"
    [ -r $overlay_root ] || err "not a readable directory: $overlay_root"

    [ -z "$target" ] && err "the target directory parameter is required"
    #[ -e $target ] || err "target directory not found: $target"
    #[ -d $target ] || err "not a directory: $target"
    [ -w $overlay_root ] || err "not a writable directory: $target"

     # checks the target directory
    if [ -e $target ]
    then
        [ -d $target ] || err "install_overlay target directory \"$target\" is not a directory"
    else
        mkdir -p $target && vverbose "install_overlay directory created: $target" || err "install_overlay unable to create target directory $target"
    fi

    verbose "Processing overlay dir $overlay_root"
    
    for  f in `ls -A  -I .gitignore $overlay_root `
    do

        if [[ $f =~ .*\.(properties|config)\.template(\.?no-git)? ]]
        then
            vvverbose "install_overlay ignored file: $f"
        else
            local source=$overlay_root/$f
            if [ -f $source ]
            then
                cp  $source $target &&  vverbose "Overlay file: $source -> $target" ||  err "unable to copy overlay file $source -> $target"
            elif [ -d $source ] 
            then
                install_overlay $source $target/$f  &&  vverbose "Ovelay directory: $source" || err "unable to proccess overlay subdir $source"
            fi 
        fi
    done
     verbose "Overlay processed"

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
# No parameter.
# Should be the las call of initialization functions based on user args (default case throw an error).
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
# No parameter.
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

# Initialize a specific local branch in a git repository
# @param $1 Repository directory
# @param $2 Remote branch name
# @param $3 Local branch name
function init_git_repository(){
    local repository_dir=$1
    local remote_branch=$2
    local local_branch=$3

    vvverbose "init_git_repository repository_dir: $repository_dir, remote_branch: $remote_branch, local_branch: \"$local_branch\""

    [ -n $repository_dir ] || err "init_git_repository: parameter repository_dir is required"
    [ -n $remote_branch ] || err "init_git_repository: parameter remote_branch is required"
    [ -n $local_branch ] || err "init_git_repository: parameter local_branch is required"

    cd $repository_dir || err "Unable to enter $repository_dir"
    
    if [ -z "`git branch --list $local_branch`" ]
    then
        verbose "Switching to branch $remote_branch (local branch $local_branch)"
        vvverbose "init_git_repository git command: git checkout -B $local_branch $remote_branch"
        git checkout -B $local_branch $remote_branch || err "unable to create branch $local_branch from $remote_branch"
    else 
        verbose "Local branch found $local_branch"
    fi
    cd - >/dev/null
}

# Resets a git repository: removes all local changes
# @param $1 Repository directory
# @param $2 Remote main branch name
# @param $3 Local branch name
function reset_git_repository(){
    local repository_dir=$1
    local main_branch=$2
    local local_branch=$3

    vvverbose "reset_git_repository repository_dir: $repository_dir, main_branch: $main_branch, local_branch: $local_branch"

    cd $repository_dir || err "Unable to enter $repository_dir"
    git checkout $main_branch || err "Unable to checkout $main_branch"
    
   [ -n "`git branch --list $local_branch`" ] \
        && { git branch -D $local_branch || err "Unable to delete $local_branch"; } \
        || verbose "Branch $local_branch not found"

    cd - > /dev/null
}

# Initializes data volumes.
# N.B.: does not handle the privileges set on the volumes.
# @param $1 The service name.
# @param $2... The volumes.
function init_volumes(){
    local service=$1
    shift
    local volumes=$*
    vvverbose "init_volume service: $service, volumes:"
    # two loops are required in order to seperate the outputs
    for volume in $volumes
    do
        vvverbose "    -$volume"
    done

    for volume in $volumes
    do
        if [ -d $volume ]
        then
            verbose "Service $service, volume $volume found"
        else
            verbose "Service $service, volume $volume has to be created"
            mkdir -p  $volume && vverbose "Service $service, volume created: $volume" || err "Service $service, unable to create volume $volume"
        fi
    done
}

# Deletes data volumes.
# N.B.: The volumes are deleted only if the purge option is set (cli arg).
# @param $1 The service name.
# @param $2... The volumes.
function reset_volumes(){
    local service=$1
    shift
    local volumes=$*
    vvverbose "reset_volume service: $service, volumes: $volume"
    if [ $PURGE_FLAG -eq 1 ] 
    then
        info "Service $service, purge option provided, volumes $volumes will be deleted."
        warn_and_wait "Service $service, deleting volumes: $BOLD$volumes$NC in 4 seconds. (CtrL + C to abort)"; 
        for volume in $volumes
        do
            if [ -d $volume ]
            then
                vvverbose "Service $service, reset_volume: $volume exists"
                sudo rm -Rf $volume && info "Service $service, $volume deleted" || err "Service $service, unable to delete volume: $volume"
            else
                vvverbose "Service $service, reset_volume: $volume does not exist"
            fi
        done
    else
        info "Service $service, purge option not provided, volumes $volumes are kept."
    fi

}


