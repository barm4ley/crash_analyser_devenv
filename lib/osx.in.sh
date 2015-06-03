# File that contains OSX related functionality

source "${ABS_SRC_PATH__COMMON}"

#---------------------------------------------------------
SYS_INSTALLER=brew
SYS_INSTALL_CMD=install
SYS_UPDATE_CMD=update
#---------------------------------------------------------
SYS_INSTALL_RET_FAILURE=1
SYS_INSTALL_RET_SUCCESS=0

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
    command_exists ${SYS_INSTALLER}
    return $?
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
    $(ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)")
    return $?
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
    sys_print_info "OSX configuration selected"

    local result=1

    $(__check_sys_installer_existence)
    local installer_existence="$?"
    result=${installer_existence}

    sys_print_warn "Installer existence: ${installer_existence}"

    if [[ ${installer_existence} != "0" ]]; then
        sys_print_warn "Installer does't exist. Trying to install it"
        $(__install_sys_installer)
        local installer_installation_res="$?"
        result=${installer_installation_res}
    else
        sys_print_info "Installer is present"
    fi

    return ${result}
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
    local result=$?
    return ${result}
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
    local result=$?
    return ${result}
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
    return 1
}

