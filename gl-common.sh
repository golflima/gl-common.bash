# 
# gl-common.bash is a library providing common utilities and functions
# for Bash scripts.
#
# Feel free to contribute to this project at:
#    https://github.com/golflima/gl-common.bash
#
# Copyright 2016-2017 Jérémy Walther (jeremy.walther@golflima.net).
#
# This file is part of gl-common.bash
#
# gl-common.bash is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# gl-common.bash is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public License
# along with gl-common.bash. If not, see <http://www.gnu.org/licenses/>


############## Setup ##############
# To setup gl-common.bash in your project
GL_COMMON_BASH_PROGRAM_VAR_PREFIX="$1"


############## Constants ##############

# Version
GL_COMMON_BASH_VERSION='0.2.0+170217';

# Special chars
# No color
NC=$'\033[0m'
# Foreground colors
BLACK=$'\033[0;30m';        DARK_GRAY=$'\033[1;30m'
RED=$'\033[0;31m';          LIGHT_RED=$'\033[1;31m'
GREEN=$'\033[0;32m';        LIGHT_GREEN=$'\033[1;32m'
BROWN=$'\033[0;33m';        YELLOW=$'\033[1;33m'
BLUE=$'\033[0;34m';         LIGHT_BLUE=$'\033[1;34m'
PURPLE=$'\033[0;35m';       LIGHT_PURPLE=$'\033[1;35m'
CYAN=$'\033[0;36m';         LIGHT_CYAN=$'\033[1;36m'
LIGHT_GRAY=$'\033[0;37m';   WHITE=$'\033[1;37m'
# Background colors
BG_BLACK=$'\033[40m';
BG_RED=$'\033[41m';
BG_GREEN=$'\033[42m';
BG_BROWN=$'\033[43m';
BG_BLUE=$'\033[44m';
BG_PURPLE=$'\033[45m';
BG_CYAN=$'\033[46m';
BG_LIGHT_GRAY=$'\033[47m';
# Controls
CLEAR_BEFORE=$'\033[1K';    CLEAR_ALL=$'\033[2K';
# Fix for old sed versions (Mac OS...)
TAB=$'\t';                  LF=$'\n';

# Spinner chars used
GL_COMMON_BASH_SPINNER_CHARS[0]='|/─\';
GL_COMMON_BASH_SPINNER_CHARS[1]='╵╶╷╴';
GL_COMMON_BASH_SPINNER_CHARS[2]='╀┾╁┽';
GL_COMMON_BASH_SPINNER_CHARS[3]='┤┘┴└├┌┬┐';
GL_COMMON_BASH_SPINNER_CHARS[4]='░▒▓█▓▒ ';
GL_COMMON_BASH_SPINNER_CHARS[5]='▄▀';

# shFlags
[[ -z "${FLAGS_TRUE}" ]] && FLAGS_TRUE=0;
[[ -z "${FLAGS_FALSE}" ]] && FLAGS_FALSE=1;



############## General functions ##############

# Gets value of given variable name, usage:
#   get_var <variable_name>
get_var() { echo -n "$(eval "echo \${$1}")"; }

# Sets value of given variable name, usage:
#   set_var <variable_name> <value>
set_var() { eval "$1=\"$2\""; }

# Gets the content of a prefixed VAR, usage:
#   gl_common_get_var <var>
gl_common_get_var() { get_var "${GL_COMMON_BASH_PROGRAM_VAR_PREFIX}$1"; }

# Initializes a variable from a prefixed environment variable, usage:
#   init_var <variable_name> <default_command> <env_prefix>
init_var() {
    local env_var="$(get_var "$3$1")"
    [[ -z "${env_var}" ]] && set_var "$1" "eval \"$2\"" || set_var "$1" "${env_var}"
}

# Displays trace information message $@ in dark gray, usage:
#   trace <text>
trace() { echo -e "${DARK_GRAY}$@${NC}"; }

# Displays variable content in dark gray, usage:
#   trace_var <variable_name>
trace_var() { echo -e "${DARK_GRAY}$1\t = $(eval "echo \${$1}")${NC}"; }

# Displays debug information message $@ in dark gray, only if flag 'debug' is set, usage:
#   debug <text>
debug() { has_flag "debug" && trace "$@"; }

# Displays variable content in dark gray, only if flag 'debug' is set, usage:
#   debug_var <variable_name>
debug_var() { has_flag "debug" && debug_var "$@"; }

# Displays information message $@ in light blue, usage:
#   info <text>
info() { echo -e "${LIGHT_BLUE}$@${NC}"; }

# Displays success message $@ in green, usage:
#   success <text>
success() { echo -e "${GREEN}$@${NC}"; }

# Displays warning message $@ in brown/orange, usage:
#   warn <text>
warn() { echo -e "${BROWN}$@${NC}" >&2; }

# Ends the execution, and displays $@ in bold red, usage:
#   die
#   die <text>
die() { warn "${LIGHT_RED}$@"; exit 1; }

# Ends the execution, and displays a last message ($@ if set, 'Done.' otherwise), usage:
#   end
#   end <text>
end() { [[ -z "$@" ]] && echo -e "${GREEN}Done.${NC}" || echo -e "${GREEN}$@${NC}"; exit 0; }

# Displays question message $1 in light purple, usage:
#   question <text>
#   question <text> <output_variable>
#   question <text> <output_variable> <default_value>
question() {
    case $# in
        1)  echo -en "${LIGHT_PURPLE}$@${NC}" ;;
        2)  read -p "${LIGHT_PURPLE}$1${NC}" $2 < /dev/tty ;;
        3)  read -p "${LIGHT_PURPLE}$1${NC}" -ei "$3" $2 < /dev/tty ;;
    esac
}

# Asks user to enter a sensible data in light purple, usage:
#   password <text> <output_variable>
password() { read -sp "${LIGHT_PURPLE}$1${NC}" $2 < /dev/tty; }

# Ends the execution if given argument $1 is empty and displays usage of subcommand $2, or global usage if $2 is empty, usage:
#   require_argument <variable_name>
#   require_argument <variable_name> <subcommand>
require_argument() { [[ -z "$(eval "echo \${$1}")" ]] && usage $2 && echo && die "Missing <$1> argument !"; }

# Loads required script file and dies if it is not found or if there is an error, usage:
#   require_script_file <file>
#   require_script_file <file> <arguments>
require_script_file() {
    ! [[ -e "$1" ]] && die "Required file '$1' not found."
    . "$@"
    local error_code=$?
    [[ "${error_code}" > 0 ]] && die "Error when loading file '$1', error_code: ${error_code}."
}

# Loads required script from URL and dies if it is not found or if there is an error, usage:
#   require_script_curl <file>
#   require_script_curl <file> <arguments>
require_script_curl() {
    local http_code="$(curl_http_code "$1")"
    [[ "${http_code}" != "200" ]] && die "Error when loading url '$1', http_code: ${http_code}."
    eval "$(curl -sL "$1")"
    local error_code=$?
    [[ "${error_code}" > 0 ]] && die "Error when loading script from '$1', error_code: ${error_code}."
}

# Ends the execution if given command $1 returns an error and displays debug information, usage:
#   assertok "command" $LINENO
assertok() { ! $1 && warn "${LIGHT_RED}fatal: $(echo gl_common_get_var NAME) v$(echo gl_common_get_var VERSION), line $2, following command failed (err: $?):" && die "$1"; }

# Removes all colors, should be called when option --no-color (-c) is used, usage:
#   remove_colors
#   [[ has_option 'c/no-color' ]] && remove_colors
remove_colors() {
    NC=; BLACK=; DARK_GRAY=; RED=; LIGHT_RED=; GREEN=; LIGHT_GREEN=;
    BROWN=; YELLOW=; BLUE=; LIGHT_BLUE=; PURPLE=; LIGHT_PURPLE=;
    CYAN=; LIGHT_CYAN=; LIGHT_GRAY=; WHITE=; BG_BLACK=; BG_RED=;
    BG_GREEN=; BG_BROWN=; BG_BLUE=; BG_PURPLE=; BG_CYAN=; BG_LIGHT_GRAY=;
}

# Checks if an option is present, usage:
#   has_option <o> "$@"
#   has_option <option> "$@"
#   has_option <o/option> "$@"
has_option() {
    local option="$1"
    while [[ $# > 1 ]]; do
        shift
        check_option "${option}" "$1" && return 0;
    done
    return 1;
}

# Gets value on an option, usage:
#   get_option <o> "$@"
#   get_option <option> "$@"
#   get_option <o/option> "$@"
get_option() {
    local option="$1"
    while [[ $# > 1 ]]; do
        shift
        if check_option "${option}" "$1"; then
            echo -n "$2"
            return 0;
        fi
    done
    return 1;
}

# Compares an option to an argument, usage:
#   check_option <o> <argument>
#   check_option <option> <argument>
#   check_option <o/option> <argument>
check_option() {
    [[ $# != 2 ]] && die "Wrong usage of check_option(), requires at least 2 arguments : $@"
    if [[ ${#1} = 1 ]]; then
        [[ "-$1" = "$2" ]] && return 0 || return 1
    fi
    [[ ${#1} < 2 ]] && die "Wrong usage of check_option(), long options must be at least 2 chars : $@"
    if [[ ${1:1:1} != '/' ]]; then
        [[ "--$1" = "$2" ]] && return 0 || return 1
    fi
    [[ ${#1} < 3 ]] && die "Wrong usage of check_option(), combined options must be at least 3 chars : $@"
    [[ "-${1:0:1}" = "$2" || "--${1:2}" = "$2" ]] && return 0
    return 1;
}

# Convenience functions for checking shFlags flags

# Gets content of a flag, with shFlags, usage:
#   get_flag <flag>
get_flag() { get_var "FLAGS_$1"; }

# Sets content of a flag, with shFlags, usage:
#   set_flag <flag> <value>
set_flag() { set_var "FLAGS_$1" "$2"; }

# Checks if a flag is empty (or not set), with shFlags, usage:
#   empty_flag <flag>
empty_flag() { [[ -z "$(get_flag "$1")" ]]; }

# Checks if a boolean flag is set, with shFlags, usage:
#   has_flag <usage>
has_flag() { [[ "$(get_flag "$1")" = "${FLAGS_TRUE}" ]]; }

# Checks if a boolean flag is not set (or false), with shFlags, usage:
#   hasnt_flag <usage>
hasnt_flag() { [[ "$(get_flag "$1")" != "${FLAGS_TRUE}" ]]; }

# Disables flags_help() function of shFlags
flags_help() { return 0; }

# Checks if a flag is set with shFlags, fallback to has_option otherwise and stores the result like shFlags does, usage:
#   has_option_wf <f> "$@"
#   has_option_wf <flag> "$@"
has_option_wf() {
    has_flag $1 && return 0;
    local option
    has_option "$@"
    option=$?
    set_flag "$1" "${option}"
    return "${option}"
}

# Gets content of a flag sets with shFlags, fallback to get_option if empty (or not set) and stores the result like shFlags does, usage:
#   get_option_wf <f> "$@"
#   get_option_wf <flag> "$@"
get_option_wf() {
    local value
    value="$(get_flag $1)"
    [[ -n "${value}" ]] && echo -n "${value}" && return 0;
    value="$(get_option "$@")"
    set_flag "$1" "${value}"
    echo -n "${value}"
    return 0;
}

# Displays a spinner at the beginning of the standard output line, usage:
#   spinner <command>
#   spinner <command> <before>
#   spinner <command> <before> <after>
#   spinner <command> <before> <after> <mode>
#   spinner <command> <before> <after> <mode> <sleep>
spinner() {
    local command="$1" before="$2" after="$3" mode="$4" sleep="$5" index=0 pid
    [[ -z "${mode}" ]] && mode="$((${RANDOM} % ${#GL_COMMON_BASH_SPINNER_CHARS[@]}))"
    [[ -z "${sleep}" ]] && sleep=0.25s
    ${command} &
    pid="$!"
    while ps -p"${pid}" -o "pid=" >/dev/null 2>&1; do
        [[ "${index}" -ge "${#GL_COMMON_BASH_SPINNER_CHARS[${mode}]}" ]] && index=0
        echo -en "\r$(eval "${before}")${GL_COMMON_BASH_SPINNER_CHARS[${mode}]:${index}:1}$(eval "${after}")"
        sleep "${sleep}"
        let index++
    done
    echo -ne "${CLEAR_ALL}\r"
}

# Displays a spinner at the beginning of the standard output line, in green, usage:
#   spinner_green <command>
#   spinner_green <command> <before>
#   spinner_green <command> <before> <after>
#   spinner_green <command> <before> <after> <mode>
spinner_green() {
    spinner "$1" "echo -en \"${LIGHT_GREEN}\"; $2" "echo -en \"${NC}\"; $3" "$4" "$5"
}

# Returns the HTTP code for given url, usage:
#   curl_http_code <url>
curl_http_code(){
    curl -s -o /dev/null -w '%{http_code}' "$1"
}

# Escapes git branch names for use in file names, usage:
#   file_escape <name>
file_escape() { echo "${1//[^[:alnum:]._-]/-}"; }

# Calls a third-party program to open/execute given file, usage:
#   file_exec <filename>
file_exec() {
    [[ -z "$1" ]] && die "Missing filename."
    [[ -f "$1" ]] || return 1;
    [[ "$1" =~ .*\.([[:alnum:]_-]+) ]] || return 2;
    local file_extension file_application
    file_extension="${BASH_REMATCH[1]}"
    file_application="$(echo gl_common_get_var "EXEC_${file_extension}")"
    [[ -z "${file_application}" ]] && return 3;
    eval "${file_application}" "$1" || trace "Failed to exec file '$1' (error code: '$?') with:\n${file_application} \"$1\""
}

# Parses and evaluate a given template, usage:
#   parse_template <template_name> <generated_file_name> <generated_file_suffix>
parse_template() {
    [[ -z "$1" ]] && die "Missing templates path."
    [[ -z "$2" ]] && die "Missing template name."
    [[ -z "$3" ]] && die "Missing default generated file name."
    local template_path template_name generated_file_name generated_file_suffix template_file lhs value rhs parsed_template
    template_path="$1"
    template_name="$2"
    generated_file_name="$3"
    generated_file_suffix="$4"
    template_file="${template_path}/${template_name}"
    if [[ -f "${template_name}" ]]; then
        template_file="${template_name}"
    fi
    if [[ ! -f "${template_file}" ]]; then
        warn "Template '${template_name}': file not found."
        return 1;
    fi
    parsed_template="$(<"${template_file}")"
    # Handle comment tags: '<%# comment #%>'
    while [[ "${parsed_template}" =~ (<%#((([^#]|#[^%]|#%[^>]))*)#%>) ]]; do
        lhs="${BASH_REMATCH[1]}"
        parsed_template="${parsed_template//"${lhs}"/}"
    done
    # Handle variable tags: '<%= variablename %>'
    while [[ "${parsed_template}" =~ (<%=[[:blank:]]*[[:cntrl:]]*[[:blank:]]*([^%[:blank:][:cntrl:]]*)[[:blank:][:cntrl:]]*%>) ]]; do
        lhs="${BASH_REMATCH[1]}"
        value="${BASH_REMATCH[2]}"
        rhs="$(eval echo -n "\"\${$value}\"")"
        if [[ $? != 0 ]]; then
            warn "Template '${template_name}': error when evaluating variable tag: '${lhs}'."
            return 10;
        fi
        parsed_template="${parsed_template//"${lhs}"/"${rhs}"}"
    done
    # Handle not echoed command tags: '<%@ command %>'
    while [[ "${parsed_template}" =~ (<%@((([^%]|%[^>]))*)%>) ]]; do
        lhs="${BASH_REMATCH[1]}"
        value="${BASH_REMATCH[2]}"
        eval "${value}"
        if [[ $? != 0 ]]; then
            warn "Template '${template_name}': error when evaluating not echoed command tag: '${lhs}'."
            return 11;
        fi
        parsed_template="${parsed_template//"${lhs}"/}"
    done
    # Handle echoed command tags: '<%$ command %>'
    while [[ "${parsed_template}" =~ (<%\$((([^%]|%[^>]))*)%>) ]]; do
        lhs="${BASH_REMATCH[1]}"
        value="${BASH_REMATCH[2]}"
        rhs="$(eval "${value}")"
        if [[ $? != 0 ]]; then
            warn "Template '${template_name}': error when evaluating echoed command tag: '${lhs}'."
            return 12;
        fi
        parsed_template="${parsed_template//"${lhs}"/"${rhs}"}"
    done
    # Handle to-file command tags: '<%: command %>'
    if [[ "${parsed_template}" =~ (<%:((([^%]|%[^>]))*)%>) ]]; then
        lhs="${BASH_REMATCH[1]}"
        value="${BASH_REMATCH[2]}"
        eval "${value}" > "${generated_file_name}${generated_file_suffix}"
        if [[ $? = 0 ]]; then
            info "Template '${template_name}': File '${generated_file_name}${generated_file_suffix}' generated."
            file_exec "${generated_file_name}${generated_file_suffix}"
            return 0;
        else
            warn "Template '${template_name}': error when evaluating to-file command tag: '${lhs}'."
            return 13;
        fi
    fi
    if [[ ! -z "${generated_file_name}${generated_file_suffix}" ]]; then
        echo -n "${parsed_template}" > "${generated_file_name}${generated_file_suffix}"
        info "Template '${template_name}': File '${generated_file_name}${generated_file_suffix}' generated."
        file_exec "${generated_file_name}${generated_file_suffix}"
    else
        info "Template '${template_name}': executed."
    fi
    return 0;
}

# Colorizes a given markdown text, usage:
#   colorize_markdown <markdown>
colorize_markdown() {
    [[ -z "$1" ]] && return 1;
    local colorized_markdown lhs rhs
    # Handle lists, emphasized elements, inline code,
    # argument name in capital letters, and citation blocks
    colorized_markdown="$(echo -n "$1" | sed \
        -e 's/^\*[[:blank:]]*\(.*\)$/    \1/g' \
        -e 's/\*\([^\*]*\)\*/'"${GREEN}"'\1'"${NC}"'/g' \
        -e 's/`\([^`]*\)`/'"${LIGHT_BLUE}"'\1'"${NC}"'/g' \
        -e 's/\([[:upper:]]\{2,\}\)/'"${BROWN}"'\1'"${NC}"'/g' \
        -e 's/^>[[:blank:]]*\(.*\)$/'"${DARK_GRAY}"'\1'"${NC}"'/g' \
        )"
    echo -en "${colorized_markdown}"
    return 0;
}

# Displays usage information, based on help file declared in variable HELP_FILE, usage:
#   usage
#   usage <command>
#   usage <command> <subcomand>
usage() {
    local help_file="$(gl_common_get_var HELP_FILE)" help_title_prefix="$(gl_common_get_var HELP_TITLE_PREFIX)" help_content
    if [[ -n "${help_file}" ]]; then
        [[ -f "${help_file}" ]] || trace "Cannot locate help file: '${help_file}'."
        help_content="$(<"${help_file}")"
        [[ "${help_content}" =~ ${help_title_prefix}[[:blank:]]*$1[[:blank:]]*$2[[:cntrl:]]*([^#]*)## ]] || \
        [[ "${help_content}" =~ ${help_title_prefix}[[:blank:]]*$1[[:cntrl:]]*([^#]*)## ]] || \
        [[ "${help_content}" =~ ${help_title_prefix}[[:cntrl:]]*([^#]*)## ]] || return 1;
        help_content="${BASH_REMATCH[1]}"
    fi
    echo -e "$(colorize_markdown "$(gl_common_get_var HELP_HEADER)\n${help_content}")"
}