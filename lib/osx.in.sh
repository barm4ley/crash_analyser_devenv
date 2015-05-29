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

function __check_sys_installer_existence() {
    echo "$(which ${SYS_INSTALLER})"
}

function __install_sys_installer() {
echo "$(ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)")"
}

#---------------------------------------------------------



function preinstall() {
    local installer_existence="$(__check_sys_installer_existence)"
    if [[ ${installer_existence} != "0" ]]; then echo "${installer_existence}"; fi

    local installer_installation_res="$(__install_sys_installer)"

    echo "${installer_installation_res}"
}

function install_package() {
    local pkg="$1"
    $(${SYS_INSTALLER} ${SYS_INSTALL_CMD} ${pkg} 1>&2 > /dev/null )

    echo "$?"
}

function update_package() {
    local pkg="$1"
    ${SYS_INSTALLER} {$SYS_UPDATE_CMD} ${pkg}
    echo "$?"
}


function postinstall() {
    echo "0"
}
#---------------------------------------------------------
