Title: Linux protip: environment for a process
Date: 2014-01-07 04:31
Category: Free Software
Tags: environ, linux, protip
Slug: linux-protip-environment-for-a-process

Just a quick pro-tip: if you need to know the environment variables for
a process, you can see them in that process' `/proc/${PID}/environ`
file. The file however shows the environment variables on one line, with
a null character as separator. With a simple **sed** you can show it
with newlines instead:

```
~$ sed -e "s:\x0:\n:g" /proc/144320/environ
TERM=xterm
SHELL=/bin/bash
OLDPWD=/home/swift/docs
USER=root
SUDO_USER=swift
SUDO_UID=1001
USERNAME=root
MAIL=/var/mail/root
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/opt/bin
PWD=/var/db/pkg/eix
...
```

The trick is to use `\x0` (hexcode 0) for the null character, which the
**sed** command then replaces with a newline.
