# File that contains OSX related functionality

source "${ABS_SRC_PATH__COMMON}"

osx_config_message="OSX configuration selected"
sys_print_info "${osx_config_message}"


#---------------------------------------------------------
SYS_INSTALLER=brew
SYS_INSTALL_CMD=install
SYS_UPDATE_CMD=update
#---------------------------------------------------------
SYS_INSTALL_RET_FAILURE="1"
SYS_INSTALL_RET_SUCCESS="0"
#---------------------------------------------------------

command_exists () {
    type "$1" &> /dev/null ;
}

#---------------------------------------------------------
# Check existence of system installation tool
# Globals:
#   SYS_INSTALLER
# Arguments:
#   None
# Returns:
#   Status of system package installation tool existence
#     "0" if exists, "1" otherwise
#---------------------------------------------------------
function __check_sys_installer_existence() {
    local result="0"
    if ! [ -x "$(command -v ${SYS_INSTALLER})" ]; then
        result="1"
    fi
    echo "${result}"
}


#---------------------------------------------------------
# Install system installation tool
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Status of system installation tool installation
#---------------------------------------------------------
function __install_sys_installer() {
echo "$(ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)")"
}


#---------------------------------------------------------
# Function that will be invoked prior all packages installation
#  In this case it should check for system installer existence
#  If it is not exist than we'll try to install it.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Status of installer exisence or installation status
#---------------------------------------------------------
function preinstall() {
    sys_print_info "Executing preinstall..."

    local installer_existence="$(__check_sys_installer_existence)"
    local result="$?"
    if [[ ${installer_existence} != "0" ]]; then
        echo "${installer_existence}"
        sys_print_warn "Installer does't exist. Trying to install it"
        local installer_installation_res="$(__install_sys_installer)"
        result="$?"
    else
        sys_print_info "Installer is present"
    fi


    echo "${result}"
}


#---------------------------------------------------------
# Function that installs package using system dependent
#   package installation tool
# Globals:
#   SYS_INSTALLER
#   SYS_INSTALL_CMD
# Arguments:
#   $1 - Name of package to install
# Returns:
#   Status of package installation
#---------------------------------------------------------
function install_package() {
    local pkg="$1"
    $(${SYS_INSTALLER} ${SYS_INSTALL_CMD} ${pkg} > /dev/null 2>&1)
    local result="$?"
    echo "${result}"
}


#---------------------------------------------------------
# Function that updates already installed package using system
#   dependent package installation tool
# Globals:
#   SYS_INSTALLER
#   SYS_UPDATE_CMD
# Arguments:
#   $1 - Name of package to update
# Returns:
#   Status of package update
#---------------------------------------------------------
function update_package() {
    local pkg="$1"
    ${SYS_INSTALLER} {$SYS_UPDATE_CMD} ${pkg}
    local result="$?"
    echo "${result}"
}


#---------------------------------------------------------
# Function that will be invoked post all packages installation
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Status of installer exisence or installation status
#---------------------------------------------------------
function postinstall() {
    sys_print_info "Executing postinstall..."

    #echo "0"
}

