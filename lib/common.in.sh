# Library for common functionality

# Standart message prefix
__SYS_PREFIX="DEVENV"

# Standart log level indication strings
__INFO_STR="INFO"
__WARN_STR="WARN"
__ERR_STR="ERR!"
__UNKNOWN_STR="????"



command_exists () {
    type "$1" &> /dev/null ;
}

#---------------------------------------------------------
# Add effects to the string
# Available effects:
#   Colors: black, red, green, yellow, blue, magenta, cyan, white
#   Effects: bold, halfbright, underline, reverseveideo, standout
# Globals:
#   None
# Arguments:
#   $1 - Strint to beautify
#   $N - List of effects to apply
# Returns:
#   Modified string
#---------------------------------------------------------
function __add_string_effects() {
    local string="$1"
    shift

    local black=`tput setaf 0`
    local red=`tput setaf 1`
    local green=`tput setaf 2`
    local yellow=`tput setaf 3`
    local blue=`tput setaf 4`
    local magenta=`tput setaf 5`
    local cyan=`tput setaf 6`
    local white=`tput setaf 7`

    local reset_term=`tput sgr0` # Reset terminal to initial state

    local bold=`tput bold`    # Select bold mode
    local dim=`tput dim`      # Select dim (half-bright) mode
    local smul=`tput smul`    # Enable underline mode
    local rmul=`tput rmul`    # Disable underline mode
    local rev=`tput rev`      # Turn on reverse video mode
    local smso=`tput smso`    # Enter standout (bold) mode
    local rmso=`tput rmso`    # Exit standout mode

    local res_str=$string

    for mod in "$@"
    do
        case ${mod} in
            black)        res_str="${black}${res_str}" ;;
            red)          res_str="${red}${res_str}" ;;
            green)        res_str="${green}${res_str}" ;;
            yellow)       res_str="${yellow}${res_str}" ;;
            blue)         res_str="${blue}${res_str}" ;;
            magenta)      res_str="${magenta}${res_str}" ;;
            cyan)         res_str="${cyan}${res_str}" ;;
            white)        res_str="${white}${res_str}" ;;

            bold)         res_str="${bold}${res_str}" ;;
            halfbright)   res_str="${dim}${res_str}" ;;
            underline)    res_str="${smul}${res_str}${rmul}" ;;
            reversevideo) res_str="${rev}${res_str}" ;;
            standout)     res_str="${smso}${res_str}${rmso}" ;;
        esac
    done

    res_str="${res_str}${reset_term}"
    echo "${res_str}"
}


#---------------------------------------------------------
# Add effects and colors to the message string dependently
#  on log level and print it
# Available effects:
#   Colors: black, red, green, yellow, blue, magenta, cyan, white
#   Effects: bold, halfbright, underline, reverseveideo, standout
# Avalilable log levels: info, warn, err
# Globals:
#   __INFO_STR
#   __WARN_STR
#   __ERR_STR
#   __UNKNOWN_STR
# Arguments:
#   $1 - Log message prefix
#   $2 - Log message body
#   $3 - Log level
# Returns:
#   None
#---------------------------------------------------------
function __colorize_report_by_level() {
    local prefix="$1"
    local msg="$2"
    local level="$3"

    local prefix_effects=""
    local message_effects=""

    # Select effects by level
    case "${level}" in
        info)
            prefix_effects=(bold green)
            message_effects=(green)
            
            level_str="${__INFO_STR}"
            ;;
        warn)
            prefix_effects=(bold yellow)
            message_effects=(yellow)
            
            level_str="${__WARN_STR}"
            ;;
        err)
            prefix_effects=(bold red underline)
            message_effects=(red underline)
            
            level_str="${__ERR_STR}"
            ;;
        *)
            prefix_effects=(bold blue halfbright)
            message_effects=(blue halfbright)
            
            level_str="${__UNKNOWN_STR}"
            ;;
    esac

    local date_format="+%H:%M:%S"

    local prefix_formatted_str=$(printf "[%s][%s][%s]:" "${prefix}" "${level_str}" "$(date ${date_format})")
    local prefix_colorized_str=$(__add_string_effects "${prefix_formatted_str}" "${prefix_effects[@]}")

    local message_formatted_str=$(printf " %s" "${msg}")
    local message_colorized_str=$(__add_string_effects "${message_formatted_str}" "${message_effects[@]}")
    
    echo "${prefix_colorized_str}${message_colorized_str}"
}


#---------------------------------------------------------
# Print log messaage with info log level
# Globals:
#   None
# Arguments:
#   $1 - Log message body to print
# Returns:
#   None
#---------------------------------------------------------
function sys_print_info() {
    local msg="$1"
    __colorize_report_by_level "${__SYS_PREFIX}" "${msg}" info
}


#---------------------------------------------------------
# Print log messaage with warn log level
# Globals:
#   None
# Arguments:
#   $1 - Log message body to print
# Returns:
#   None
#---------------------------------------------------------
function sys_print_warn() {
    local msg="$1"
    __colorize_report_by_level "${__SYS_PREFIX}" "${msg}" warn 1>&2
}


#---------------------------------------------------------
# Print log messaage with err log level
# Globals:
#   None
# Arguments:
#   $1 - Log message body to print
# Returns:
#   None
#---------------------------------------------------------
function sys_print_err() {
    local msg="$1"
    __colorize_report_by_level "${__SYS_PREFIX}" "${msg}" err 1>&2
}


