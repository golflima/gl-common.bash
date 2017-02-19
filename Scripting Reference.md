# gl-common.bash scripting refence

## Setup

### From local filesystem

```bash
# Load gl-common.bash
readonly MYAPP_DIR=$(dirname "$(echo "$(readlink -f "$0")" | sed -e 's,\\,/,g')")
. "${MYAPP_DIR}/gl-common.sh" MYAPP_
if [[ $? > 0 ]]; then echo "Error when loading file '${MYAPP_DIR}/gl-common.sh'"; exit 1; fi
```

### From remote URL

```bash
# Load gl-common.bash from a remote URL
eval "$(curl -sL https://raw.githubusercontent.com/golflima/gl-common.bash/master/gl-common.sh)"
if [[ $? > 0 ]]; then echo "Error when loading gl-common.sh"; exit 1; fi
gl_common_set_var_prefix MYAPP_
```

## Variable prefix and special variables

*gl-common.bash* uses a prefix to identify special variables to enable some features for your scripts.

* `gl_common_get_var_prefix` displays current variable prefix used
* `gl_common_set_var_prefix PREFIX` sets the prefix to *PREFIX*

### Special variables

* `<PREFIX>NAME` is the name of your script/program/application, used by `assertok`
* `<PREFIX>VERSION` is the version of your script/program/application, used by `assertok`
* `<PREFIX>EXEC_<FILE_EXTENSION>` is the path to the program to use when openning file with `file_exec` with given `<FILE_EXTENSION>`
* `<PREFIX>HELP_TITLE_PREFIX` is the prefix of title sections to ignore when calling `usage`
* `<PREFIX>HELP_HEADER` is the text to displays always first when calling `usage`

Note: `<PREFIX>` in above special variables must be replaced by your prefix.

These variables can be accessed and assigned with these commands, without specifying the prefix:

* `gl_common_get_var NAME` gets the value of normally prefixed variable *NAME*
* `gl_common_set_var NAME VALUE` gets the *VALUE* of normally prefixed variable *NAME*

## Global variables

### gl-common.bash variables

* `${GL_COMMON_BASH_VERSION}` contains the current version of gl-common.bash
* `${GL_COMMON_BASH_PROGRAM_VAR_PREFIX}` stores the variable prefix for current application/script

### Text formatting

* `${NC}` clears all formatting (reset to default)
* `${BLACK}` will output following text in *black*
* `${DARK_GRAY}` will output following text in *dark grey*
* `${RED}` will output following text in *red*
* `${LIGHT_RED}` will output following text in *light red*
* `${GREEN}` will output following text in *green*
* `${LIGHT_GREEN}` will output following text in *light green*
* `${BROWN}` will output following text in *brown / dark yellow*
* `${YELLOW}` will output following text in *yellow*
* `${BLUE}` will output following text in *blue*
* `${LIGHT_BLUE}` will output following text in *light blue*
* `${PURPLE}` will output following text in *purple*
* `${LIGHT_PURPLE}` will output following text in *light purple*
* `${CYAN}` will output following text in *cyan*
* `${LIGHT_CYAN}` will output following text in *light cyan*
* `${LIGHT_GRAY}` will output following text in *light gray*
* `${BG_BLACK}` will output following background text in *black*
* `${BG_RED}` will output following background text in *red*
* `${BG_GREEN}` will output following background text in *green*
* `${BG_BROWN}` will output following background text in *brown / dark yellow*
* `${BG_BLUE}` will output following background text in *blue*
* `${BG_PURPLE}` will output following background text in *purple*
* `${BG_CYAN}` will output following background text in *cyan*
* `${BG_LIGHT_GRAY}` will output following background text in *light gray*
* `${CLEAR_BEFORE}` clears all characters on the current line before current position
* `${CLEAR_ALL}` clears the whole current line
* `${TAB}` outputs a tabulation, equivalent to `\t`
* `${LF}` outputs a line feed, equivalent to `\n`

### shFlags compatibility

* `${FLAGS_TRUE}` is set to `0` if not already set, for compatibility with shFlags
* `${FLAGS_FALSE}` is set to `1` if not already set, for compatibility with shFlags

## Variable manipulation

* `get_var VARIABLE_NAME` gets the value of given variable name in *VARIABLE_NAME*
* `set_var VARIABLE_NAME VALUE` sets the value of given variable name in *VARIABLE_NAME* with value in *VALUE*
* `init_var NAME COMMAND` checks if variable *NAME* is defined or sets its value to standard output of given *COMMAND* otherwise
* `init_var NAME COMMAND PREFIX` checks if variable *PREFIXNAME* is defined and sets its value to variable *NAME* or sets value of variable *NAME* to standard output of given *COMMAND* otherwise

## Pipes

*Note : Commands below must be used in pipes only.*

* `escape_piped` escapes the value of previous piped command
* `echo_piped` echoes the content of previous piped command
* `echo_piped OPTIONS` echoes the content of previous piped command with given `echo` *OPTIONS*

## User interactions

* `trace TEXT` displays *TEXT* in dark grey
* `trace_var NAME` displays name of given variable *NAME* and its content in dark grey
* `debug TEXT` displays *TEXT* in dark grey, only if flag `debug` is set
* `debug_var NAME` displays name of given variable *NAME* and its content in dark grey, only if flag `debug` is set
* `info TEXT` displays *TEXT* in light blue
* `success TEXT` displays *TEXT* in green
* `warn TEXT` displays *TEXT* in brown / dark yellow
* `die` exists script's execution with return code `1`
* `die TEXT` exists script's execution with return code `1` and displays *TEXT* in light red
* `end` exists script's execution with return code `0`
* `end TEXT` exists script's execution with return code `0` and displays *TEXT* in green
* `question TEXT` displays *TEXT* in light purple
* `question TEXT NAME` displays *TEXT* in light purple and stores user's input (always from `/dev/tty`) (validated with [Enter] key) in variable *NAME*
* `question TEXT NAME DEFAULT` displays *TEXT* in light purple and stores user's input, prefilled with default value *DEFAULT*, (always from `/dev/tty`) (validated with [Enter] key) in variable *NAME*
* `password TEXT NAME` displays *TEXT* in light purple and stores user's input (always from `/dev/tty`) but without displaying it

