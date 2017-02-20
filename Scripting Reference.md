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

## Variable manipulation

* `get_var VARIABLE_NAME` gets the value of given variable name in *VARIABLE_NAME*
* `set_var VARIABLE_NAME VALUE` sets the value of given variable name in *VARIABLE_NAME* with value in *VALUE*

> [Example](examples/colors)

### shFlags compatibility

* `${FLAGS_TRUE}` is set to `0` if not already set, for compatibility with shFlags
* `${FLAGS_FALSE}` is set to `1` if not already set, for compatibility with shFlags

## Variable manipulation

* `get_var VARIABLE_NAME` gets the value of given variable name in *VARIABLE_NAME*
* `set_var VARIABLE_NAME VALUE` sets the value of given variable name in *VARIABLE_NAME* with value in *VALUE*
* `init_var NAME COMMAND` checks if variable *NAME* is defined or sets its value to standard output of given *COMMAND* otherwise
* `init_var NAME COMMAND PREFIX` checks if variable *PREFIXNAME* is defined and sets its value to variable *NAME* or sets value of variable *NAME* to standard output of given *COMMAND* otherwise

> [Example](examples/variables)

## Pipes

*Note : Commands below must be used in pipes only.*

* `escape_piped` escapes the value of previous piped command
* `echo_piped` echoes the content of previous piped command
* `echo_piped OPTIONS` echoes the content of previous piped command with given `echo` *OPTIONS*

> [Example](examples/variables)

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
* `remove_colors` disables all colors, typically called this way: `[[ has_option 'c/no-color' ]] && remove_colors`

> [Example](examples/text)

## Script's options

### Options

* `has_option OPTION "$@"` checks if option *OPTION* was passed to the script
* `get_option OPTION "$@"` gets value of option *OPTION* passed to the script

Note: *OPTION* in commands above can be formed like:

* `O` to represent a simple option, passed like `-O` to the script
* `OPTION` to represent a long option, passed like `--OPTION` to the script
* `'O/OPTION'` to represent either a simple option `-O` or a long option `--OPTION` passed to the script

> [Example](examples/flags)

### shFlags

*gl-common.bash* provides some functions to easily deals with [*shFlags*](https://github.com/kward/shflags). It is not mandatory to use it when using *gl-common.bash*, and following functions are compatible with *shFlags*:

* `has_flag FLAG` checks if *FLAG* was passed to the script
* `hasnt_flag FLAG` checks if *FLAG* wasn't passed to the script
* `empty_flag FLAG` checks if *FLAG* value is empty
* `get_flag FLAG` gets value of *FLAG* passed to the script
* `set_flag FLAG VALUE` sets *VALUE* of given *FLAG*

Note: *FLAG* in commands above can be formed like:

* `F` to represent a simple flag, passed like `-F` to the script
* `FLAG` to represent a long flag, passed like `--FLAG` to the script

Note: *gl-common.bash* automatically disables the *help* feature of *shFlags* because it already have its powerfull `usage` function.

### Using Options to deals with shFlags

*gl-common.bash* is able to dynamically bind *options* to *flags* with following functions. They more effective, but less powerfull:

* `has_option_wf FLAG "$@"` checks if *FLAG* is set with *shFlags*, fallback to `has_option FLAG` otherwise and stores the result like *shFlags* does
* `get_option_wf FLAG "$@"` gets content of *FLAG* sets with *shFlags*, fallback to `get_option FLAG` if empty (or not set) and stores the result like *shFlags* does

Note: *FLAG* in commands above can be formed like:

* `F` to represent a simple flag, passed like `-F` to the script
* `FLAG` to represent a long flag, passed like `--FLAG` to the script

> [Example](examples/flags)

## URL manipuation

* `curl_http_code URL` returns the HTTP code for given *URL*
* `curl_http_code URL OPTIONS` returns the HTTP code for given *URL* and applies given *curl* *OPTIONS*

> [Example](examples/spinner)

## Script's documentation in Markdown

* `colorize_markdown TEXT` displays a colorized version of given markdown *TEXT*
* `usage` displays general script's help contained in section *HELP_TITLE_PREFIX* of given help file *HELP_FILE*, preceeded by the text contained in *HELP_HEADER*
* `usage COMMAND` displays script's help for *COMMAND* contained in section *HELP_TITLE_PREFIX* *COMMAND* of given help file *HELP_FILE*, preceeded by the text contained in *HELP_HEADER*
* `usage COMMAND SUBCOMMAND` displays script's help for *COMMAND* *SUBCOMMAND* contained in section *HELP_TITLE_PREFIX* *COMMAND* *SUBCOMMAND* of given help file *HELP_FILE*, preceeded by the text contained in *HELP_HEADER*

> [Example](examples/usage)

## Spinners for long operations

* `spinner COMMAND` displays a spinner while executing *COMMAND* and returns its standard output
* `spinner COMMAND BEFORE` displays a spinner while executing *COMMAND* and returns its standard output, and append result of command *BEFORE* before the spinner
* `spinner COMMAND BEFORE AFTER` displays a spinner while executing *COMMAND* and returns its standard output, and append result of commands *BEFORE* and *AFTER* respectively before and after the spinner
* `spinner COMMAND BEFORE AFTER MODE` displays a spinner while executing *COMMAND* and returns its standard output, and append result of commands *BEFORE* and *AFTER* respectively before and after the spinner, and force spinner display to given *MODE*
* `spinner COMMAND BEFORE AFTER MODE SLEEP` displays a spinner while executing *COMMAND* and returns its standard output, and append result of commands *BEFORE* and *AFTER* respectively before and after the spinner, and force spinner display to given *MODE*, and force spinner refresh rate to given *SLEEP* time between each frame
* `spinner_green` behaves exactly like `spinner` and accepts the same arguments, except it force the color of spinner to light green

> [Example](examples/spinner)
