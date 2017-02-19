# gl-common.bash - Useful functions for Bash scripting

*gl-common.bash* aims to improve writing of Bash scripts and provides several useful functions for scripting.

Key features:

* Standardized user interactions for outputs and inputs
* Variable manipulation
* Handle portable basic options for scripts
* Simplifies use of shFlags
* Easy documentation of your scripts with Markdown

And it has many free [examples](examples).



## How to include gl-common.bash in your scripts?

### Ship gl-common.bash with your scripts

1. [Download the file](https://raw.githubusercontent.com/golflima/gl-common.bash/master/gl-common.sh) or [clone the git repository](https://github.com/golflima/git-xflow.git)
2. Then, load the file in your script with:

```bash
# Load gl-common.bash
readonly MYAPP_DIR=$(dirname "$(echo "$(readlink -f "$0")" | sed -e 's,\\,/,g')")
. "${MYAPP_DIR}/gl-common.sh" MYAPP_
if [[ $? > 0 ]]; then echo "Error when loading file '${MYAPP_DIR}/gl-common.sh'"; exit 1; fi
```

You may want to replace `MYAPP_` with your very own prefix.


### Load gl-common.bash from the Internet

In your script, put:

```bash
# Load gl-common.bash from a remote URL
eval "$(curl -sL https://raw.githubusercontent.com/golflima/gl-common.bash/master/gl-common.sh)"
if [[ $? > 0 ]]; then echo "Error when loading gl-common.sh"; exit 1; fi
gl_common_set_var_prefix MYAPP_
```

You may want to replace `MYAPP_` with your very own prefix.



## Scripting reference

[View *gl-common.bash* scripting reference.](Scripting Reference.md)



__________________________________________________

## Licence terms

*gl-common.bash* is published under the terms of [GNU Lesser General Public License v3](http://www.gnu.org/licenses/lgpl-3.0.html), see the [LICENSE](LICENSE) file.

Although the GNU LGPLv3 does not require you to share any modifications you make to the source code,
you are very much encouraged and invited to contribute back your modifications to the community, preferably in a Github fork, of course.



## Support

You can support this project with
[![Flattr](https://button.flattr.com/flattr-badge-large.png)](https://flattr.com/submit/auto?fid=0ywe2d&url=https%3A%2F%2Fgithub.com%2Fgolflima%2Fgl-common.bash)