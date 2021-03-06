Title: Working on a new selinuxnode VM
Date: 2013-02-23 14:04
Category: Gentoo
Tags: evm, Gentoo, hardened, ima, selinux, selinuxnode, vm
Slug: working-on-a-new-selinuxnode-vm

A long time ago, I made a [SELinux enabled
VM](http://distfiles.gentoo.org/experimental/amd64/qemu-selinux/) for
people to play with, displaying a minimal Gentoo installation, including
the hardening features it supports (PIE/PIC toolchain, grSecurity, PaX
and SELinux). I'm currently trying to create a new one, which also
includes IMA/EVM, but it looks like I still have many things to
investigate further...

First of all, I notice that many SELinux domains want to use the mknod
capability, even for domains of which I have no idea whatsoever why they
need it. I don't notice any downsides though, and running in permissive
mode doesn't change the domain behavior. But still, I'm reluctant to
mark them dontaudit as long as I'm not 100% sure.

Second, the gettys (I think it is the getty) result in a "Cannot change
SELinux context: permission denied" error, even though everything is
running in the right SELinux context. I still have to confirm if it
really is the getty process or something else (the last run I had the
impression it was a udev-related process). But there are no denials and
no SELinux errors in the logs.

Third, during shutdown, many domains have problems accessing their PID
files in /var/run (which is a link to /run). I most likely need to allow
read privileges on all domains that have access to var\_run\_t towards
the var\_t symlinks. It isn't a problem per se (the processes still run
correctly) but ugly as hell, and if you introduce monitoring it'll go
haywire (as no PID files were either found, or were stale).

Also, EVM is giving me a hard time, not allowing me to change mode and
ownership in files on /var/run. I have received some feedback from the
IMA user list on this so it is still very much a work-in-progress.

Finally, the first attempt to generate a new VM resulted in a download
of 817 MB (instead of the 158 MB of the previous release), so I still
have to correct my USE flags and doublecheck the installed applications.
Anyway, definitely to be continued. Too bad time is a scarce resource
:-(
