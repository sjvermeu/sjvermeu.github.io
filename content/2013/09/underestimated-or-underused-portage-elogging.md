Title: Underestimated or underused: Portage (e)logging
Date: 2013-09-25 10:09
Category: Gentoo
Tags: elog, Gentoo, logging, portage
Slug: underestimated-or-underused-portage-elogging

Within 30 minutes of each other, two people on the `#gentoo` channel
asked if Portage kept logs of the messages displayed during the build
and installation of a package. Of course, the answer is a sounding "yes"
- and depending on your needs, you can even save more of the logging. If
you haven't read the [Gentoo
handbook](http://www.gentoo.org/doc/en/handbook) yet, do so - it
contains a section on [Logging
Features](http://www.gentoo.org/doc/en/handbook/handbook-x86.xml?part=3&chap=1#doc_chap4)
that explains how and when logging is enabled.

Let's start with the default *elog* support. By default, Gentoo's
Portage will log messages that ebuild developers have put in the
packages through the use of the `elog`, `ewarn` and `eerror` functions.
These methods are used by the developers to notify the administrator
about something useful or important (usually `elog`), a potential issue
that might occur (`ewarn`) or even a problem that was found (`eerror`).
Let's look at a snippet of the `app-admin/eselect-postgresql-1.0.10`
package:

    pkg_postinst() {
        ewarn "If you are updating from app-admin/eselect-postgresql-0.4 or older, run:"
        ewarn
        ewarn "    eselect postgresql update"
        ewarn
        ewarn "To get your system in a proper state."
        elog "You should set your desired PostgreSQL slot:"
        elog "    eselect postgresql list"
        elog "    eselect postgresql set "
    }

Here, the developer warns the administrator that, if an upgrade of the
package from version 0.4 or older occurred, an additional action needs
to be taken. For others, he informs the administrators how to mark the
proper active PostgreSQL slot (using the `elog` methods).

Portage will save this information by default in `/var/log/portage/elog`
as separate files for each deployment:

    ~$ ls /var/log/portage/elog/*eselect-postgres*
    /var/log/portage/elog/app-admin:eselect-postgresql-1.0.10:20130818-184756.log
    /var/log/portage/elog/app-admin:eselect-postgresql-1.2.0:20130915-131631.log
    /var/log/portage/elog/app-admin:eselect-postgresql-1.2.0:20130915-200851.log

If `FEATURES="split-elog"` is set in your `make.conf` file, then the
elog files will be stored in separate category subdirectories. Below is
the content of such a single file:

    ~$ cat /var/log/portage/elog/app-admin\:eselect-postgresql-1.0.10\:20130818-184756.log
    INFO: setup
    Package:    app-admin/eselect-postgresql-1.0.10
    Repository: gentoo
    Maintainer: titanofold@gentoo.org postgresql
    USE:        abi_x86_64 amd64 elibc_glibc kernel_linux multilib selinux userland_GNU
    FEATURES:   preserve-libs sandbox selinux sesandbox
    WARN: postinst
    If you are updating from app-admin/eselect-postgresql-0.4 or older, run:

        eselect postgresql update

    To get your system in a proper state.
    LOG: postinst
    You should set your desired PostgreSQL slot:
        eselect postgresql list
        eselect postgresql set <slot>

In the file, package information is provided, and each set of logging
paragraphs is accompanied with information where in the build process
the logging came up. For instance, `WARN: postinst` sais that the
following text is through the `ewarn` method in the post install phase
of the package installation process.

By default Portage logs this, but you can ask it to mail the logs as
well. For more information about that, check the handbook link earlier
and look for the `PORTAGE_ELOG_SYSTEM` and `PORTAGE_ELOG_MAIL*`
variables. Or look at **man make.conf** which also contains all the
information needed.

Now, this only pertains to the specific logging that ebuild maintainers
added in the packages. But what if you want to keep track of all the
build logs? In that case, you need to define `PORT_LOGDIR` in your
`make.conf` file. This variable has to point to a location where Portage
(which usually runs as the `portage` Linux user) has write access to and
where it is allowed to store the build logs:

    ~$ grep PORT_LOGDIR /etc/portage/make.conf 
    PORT_LOGDIR="/var/log/portage"
    ~$ ls -ldZ /var/log/portage/
    drwxrwsr-x. 3 portage portage system_u:object_r:portage_log_t 679936 Sep 24 13:12 /var/log/portage/

With the variable set, build logs will be provided for each emerge (and
unmerge) operation of the package. These logs contain everything shown
on the terminal during a build process. Of course, this directory will
grow considerably in size so it is wise to properly handle old log
files. You can use logrotate for this, or just a single cronjob that
cleans up log files older than say 6 months. But Portage also provides
this functionality. If you set `FEATURES="clean-logs"` in your
`make.conf` file, then all log files older than 7 days will be removed
from the system. You can fine-tune this by setting `PORT_LOGDIR_CLEAN`
to the command you want executed. Its default value can be found in the
`/usr/share/portage/config/make.globals` file.

If you set `PORT_LOGDIR`, be aware that the elog files (described at the
beginning) will be stored in `${PORT_LOGDIR}/elog`. Similar to the
elogging, build logging can also be done in category subdirectories. If
`FEATURES="split-log"` is set, the build logs will be stored in
`${PORT_LOGDIR}/build/<category>` instead of `${PORT_LOGDIR}` directly.

Hopefully this post brings some users closer to this nice feature of
Portage.
