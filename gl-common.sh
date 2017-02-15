# 
# gl-common.bash is a library providing common utilities and functions
# for Bash scripts.
#
# Feel free to contribute to this project at:
#    https://github.com/golflima/gl-common.bash
#
# Copyright 2016 Jérémy Walther (jeremy.walther@golflima.net).
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
GL_COMMON_BASH_VERSION="0.1.0+161121.2222"

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
TAB=$'\t';                  LF=$'\n'

# Spinner chars used
GL_COMMON_BASH_SPINNER_CHARS='|/-\'



############## General functions ##############

# Gets the content of a prefixed VAR
gl_common_get_var() {
    echo -n "${$(echo -n "${GL_COMMON_BASH_PROGRAM_VAR_PREFIX}_$1")}"
}

# Displays trace information message $@ in dark gray
trace() { echo -e "${DARK_GRAY}$@${NC}"; }
trace_var() { echo -e "${DARK_GRAY}$1\t = $(eval "echo \${$1}")${NC}"; }
debug() { has_flag "debug" && trace "$@"; }
debug_var() { has_flag "debug" && debug_var "$@"; }

# Displays information message $@ in light blue
info() { echo -e "${LIGHT_BLUE}$@${NC}"; }

# Displays success message $@ in green
success() { echo -e "${GREEN}$@${NC}"; }

# Displays warning message $@ in brown/orange (overriden from gitflow-common)
warn() { echo -e "${BROWN}$@${NC}" >&2; }

# Ends the execution, and displays $@ in bold red (overriden from gitflow-common)
die() { warn "${LIGHT_RED}$@"; exit 1; }

# Ends the execution, and displays a last message ($@ if set, 'Done.' otherwise)
end() { [[ -z "$@" ]] && echo -e "${GREEN}Done.${NC}" || echo -e "${GREEN}$@${NC}"; exit 0; }

# Displays question message $@ in light purple
question() { echo -en "${LIGHT_PURPLE}$@${NC}"; }

# Ends the execution if given argument $1 is empty and displays usage of subcommand $2, or global usage if $2 is empty
require_argument() { [[ -z "$(eval "echo \${$1}")" ]] && usage $2 && echo && die "Missing <$1> argument !"; }

# Ends the execution if given command $1 returns an error and displays debug information. Usage: 'assertok "command" $LINENO'
assertok() { ! $1 && warn "${LIGHT_RED}fatal: $(echo gl_common_get_var NAME) v$(echo gl_common_get_var VERSION), line $2, following command failed (err: $?):" && die "$1"; }

# Remove all colors, should be called when option --no-color (-c) is used
remove_color() {
    NC=; BLACK=; DARK_GRAY=; RED=; LIGHT_RED=; GREEN=; LIGHT_GREEN=;
    BROWN=; YELLOW=; BLUE=; LIGHT_BLUE=; PURPLE=; LIGHT_PURPLE=;
    CYAN=; LIGHT_CYAN=; LIGHT_GRAY=; WHITE=;
}

# Make a spinner at the beginning of the standard output line
spinner() {
    local command="$1" before="$2" after="$3" index=0 pid
    ${command} &
    pid="$!"
    while ps -p"${pid}" -o "pid=" >/dev/null 2>&1; do
        let index++
        [[ "${index}" -ge "${#GL_COMMON_BASH_SPINNER_CHARS}" ]] && index=0
        echo -en "\r$(eval "${before}")${GL_COMMON_BASH_SPINNER_CHARS:${index}:1}$(eval "${after}")"
        sleep 0.25
    done
    echo -ne "${CLEAR_ALL}\r"
}

# Make a spinner at the beginning of the standard output line, in green
spinner_green() {
    spinner "$1" "echo -en \"${LIGHT_GREEN}\"; $2" "echo -en \"${NC}\"; $3"
}

# Convenience functions for checking shFlags flags
get_flag() { local flag; flag="FLAGS_$1"; echo -n "$(eval "echo -n \${${flag}}")"; }
set_flag() { local flag; flag="FLAGS_$1"; eval "\${${flag}}=\"$2\""; }
empty_flag() { [[ -z "$(get_flag "$1")" ]]; }
has_flag() { [[ "$(get_flag "$1")" = "${FLAGS_TRUE}" ]]; }
hasnt_flag() { [[ "$(get_flag "$1")" != "${FLAGS_TRUE}" ]]; }

# Escape git branch names for use in file names
file_escape() { echo "${1//[^[:alnum:]._-]/-}"; }

# Call a third-party program to open/execute given file. Usage: 'file_exec <filename>'
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

# Parse and evaluate a given template. Usage: 'parse_template <template_name> <generated_file_name> <generated_file_suffix>'
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

# Disable flags_help() function of shFlags
flags_help() { return 0; }

# Colorize a given markdown text
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

# Display usage information
usage() {
    local help_file help_content
    help_file="$(echo gl_common_get_var HELP_FILE)"
    [[ -f "${help_file}" ]] || die "Cannot locate help file: '${help_file}'."
    help_content="$(<"${help_file}")"
    [[ "${help_content}" =~ $(echo gl_common_get_var HELP_TITLE_PREFIX)[[:blank:]]*$1[[:blank:]]*$2[[:cntrl:]]*([^#]*)## ]] || \
    [[ "${help_content}" =~ $(echo gl_common_get_var HELP_TITLE_PREFIX)[[:blank:]]*$1[[:cntrl:]]*([^#]*)## ]] || \
    [[ "${help_content}" =~ $(echo gl_common_get_var HELP_TITLE_PREFIX)[[:cntrl:]]*([^#]*)## ]] || return 1;
    help_content="${BASH_REMATCH[1]}"
    echo -e "$(colorize_markdown "${help_header}\n${help_content}")"
}