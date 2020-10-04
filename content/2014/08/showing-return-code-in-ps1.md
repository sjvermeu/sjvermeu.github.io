Title: Showing return code in PS1
Date: 2014-08-31 01:14
Category: Gentoo
Tags: bash, ps1, rc, shell
Slug: showing-return-code-in-ps1

If you do daily management on Unix/Linux systems, then checking the
return code of a command is something you'll do often. If you do SELinux
development, you might not even notice that a command has failed without
checking its return code, as policies might prevent the application from
showing any output.

To make sure I don't miss out on application failures, I wanted to add
the return code of the last executed command to my PS1 (i.e. the prompt
displayed on my terminal).  
I wasn't able to add it to the prompt easily - in fact, I had to use a
bash feature called the *prompt command*.

When the `PROMPT_COMMMAND` variable is defined, then bash will execute
its content (which I declare as a function) to generate the prompt.
Inside the function, I obtain the return code of the last command (`$?`)
and then add it to the PS1 variable. This results in the following code
snippet inside my `~/.bashrc`:

``` {lang="bash"}
export PROMPT_COMMAND=__gen_ps1

function __gen_ps1() {
  local EXITCODE="$?";
  # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
  if type -P dircolors >/dev/null ; then
    if [[ -f ~/.dir_colors ]] ; then
      eval $(dircolors -b ~/.dir_colors)
    elif [[ -f /etc/DIR_COLORS ]] ; then
      eval $(dircolors -b /etc/DIR_COLORS)
    fi
  fi
  
  if [[ ${EUID} == 0 ]] ; then
    PS1="RC=${EXITCODE} \[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] "
  else
    PS1="RC=${EXITCODE} \[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "
  fi
}
```

With it, my prompt now nicely shows the return code of the last executed
command. Neat.

*Edit:* Sean Patrick Santos showed me my utter failure in that this can
be accomplished with the `PS1` variable immediately, without using the
overhead of the `PROMPT_COMMAND`. Just make sure to properly escape the
`$` sign which I of course forgot in my late-night experiments :-(.
