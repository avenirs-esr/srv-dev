# #! /bin/bash

#--------------------------------------#
# Clean script for Avenirs portfolio   #
#                                      #
# Removes all the modifications:       #
# - Reverts the modifications from the #
#   repositories                       #
#--------------------------------------#

AVENIRS_PORTFOLIO_SCRIPT_DIR=`dirname $0`

# Initialization
. $AVENIRS_PORTFOLIO_SCRIPT_DIR/../../../scripts/srv-dev-commons.sh
init_commons $*

info "Avenirs portfolio cleaning started."
. $AVENIRS_PORTFOLIO_SCRIPT_DIR/avenirs-portfolio-env.sh $AVENIRS_PORTFOLIO_SCRIPT_DIR 2> /dev/null \
    || err "Unable to source $AVENIRS_PORTFOLIO_SCRIPT_DIR/avenirs-portfolio-env.sh"


# ---- avenirs-portfolio-security

# Resets the repository
reset_git_repository $AVENIRS_PORTFOLIO_SECURITY_REPOSITORY_DIR $AVENIRS_PORTFOLIO_SECURITY_MAIN_BRANCH $AVENIRS_PORTFOLIO_SECURITY_LOCAL_BRANCH

# Removes the overlay's files
remove_overlay $AVENIRS_PORTFOLIO_SECURITY_REPOSITORY_DIR

# Removes the generated database sql files
remove_file $AVENIRS_PORTFOLIO_SECURITY_CLEAN_DB_CLEAR
remove_file $AVENIRS_PORTFOLIO_SECURITY_CLEAN_TEST_DB_CLEAR
remove_file $AVENIRS_PORTFOLIO_SECURITY_INIT_DB_CLEAR
remove_file $AVENIRS_PORTFOLIO_SECURITY_INIT_TEST_DB_CLEAR

remove_file $AVENIRS_PORTFOLIO_API_CLEAN_DB_CLEAR
remove_file $AVENIRS_PORTFOLIO_API_INIT_DB_CLEAR

verbose "Database initialization files removed."


info "Avenirs portfolio cleaning completed."
