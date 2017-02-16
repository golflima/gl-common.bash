# gl-common.bash scripting refence

## Special variables

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