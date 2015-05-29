# Select proper update functionality based on OS type

#SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Short OS names
readonly __OS_NAME_OSX="osx"           # Mac OSX
readonly __OS_NAME_LINUX="linux"
readonly __OS_NAME_WINDOWS="windows"   # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
readonly __OS_NAME_CYGWIN="cygwin"     # POSIX compatibility layer and Linux environment emulation for Windows
readonly __OS_NAME_SOLARIS="solaris"
readonly __OS_NAME_BSD="bsd"

#readonly __OS_NAME_OSX="OSX"           # Mac OSX
#readonly __OS_NAME_LINUX="linux"
#readonly __OS_NAME_WINDOWS="windows"   # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
#readonly __OS_NAME_CYGWIN="cygwin"     # POSIX compatibility layer and Linux environment emulation for Windows
#readonly __OS_NAME_SOLARIS="solaris"
#readonly __OS_NAME_BSD="bsd"


function __failure_on_unsupported() {
    local os_type="$1"
    sys_print_err "Sorry OS " "${os_type}" " is not supported yet."
    exit 1
}


#---------------------------------------------------------
# Get OS type name
# Globals:
#   OSTYPE
# Arguments:
#   None
# Returns:
#   Long system name string
#---------------------------------------------------------
function __get_os_type() {
    echo "${OSTYPE}"
}

#---------------------------------------------------------
# Get short system name
# Globals:
#   __OS_NAME_OSX
#   __OS_NAME_LINUX
#   __OS_NAME_WINDOWS
#   __OS_NAME_CYGWIN
#   __OS_NAME_SOLARIS
#   __OS_NAME_BSD
# Arguments:
#   None
# Returns:
#   Short system name string
#---------------------------------------------------------
function __get_os_name() {
    local os_type="$(__get_os_type)"
    os_name=""
    case "${os_type}" in
        darwin*)   os_name="${__OS_NAME_OSX}" ;;
        linux*)    os_name="${__OS_NAME_LINUX}" ;;
        msys*)     os_name="${__OS_NAME_WINDOWS}" ;;
        cygwin*)   os_name="${__OS_NAME_CYGWIN}" ;;
        solaris*)  os_name="${__OS_NAME_SOLARIS}" ;;
        bsd*)      os_name="${__OS_NAME_BSD}" ;;
        *)         __failure_on_unsupported "${os_type}" ;;
    esac
    echo "${os_name}"
}


#---------------------------------------------------------
# Include OS dependent source file
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#---------------------------------------------------------
function include_os_setting_source() {
src_path="ABS_SRC_PATH__"$(convert_string_to_uppercase $(__get_os_name))
    source "${!src_path}"
}
