


#---------------------------------------------------------
# Detect directory this scipt is located in
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

__SOURCE_FILES=()

__SRC_VAR_PREFIX="ABS_SRC_PATH__"

function convert_string_to_uppercase() {
    local str="$1"
    local res=$(echo "${str}" | tr '[:lower:]' '[:upper:]')
    echo "${res}"
}

function __make_sourch_files_list() {
    #set -x
    local filename=""
    for filename in ${SCRIPT_DIR}/*.sh; do
        __SOURCE_FILES+=(${filename})
    done
    #set +x
}


function __extract_file_stripped_basename() {
    local filename="$1"
    local base=$(basename ${filename}) 
    local stripped=${base%%.*}
    echo "${stripped}"
}


function __make_vars() {
    local filename=""
    echo "Generating source paths:"
    for filename in ${__SOURCE_FILES[@]}; do
        local suffix=$(convert_string_to_uppercase $(__extract_file_stripped_basename ${filename}))
        local var_name=${__SRC_VAR_PREFIX}${suffix}
        echo -e ' \t ' $var_name"="${filename}
        eval ${var_name}=${filename}

    done
}

__make_sourch_files_list
__make_vars


