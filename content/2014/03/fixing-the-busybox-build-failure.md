Title: Fixing the busybox build failure
Date: 2014-03-26 14:18
Category: Gentoo
Tags: busybox, genkernel, Gentoo, initramfs, initrd, noexec, tmp
Slug: fixing-the-busybox-build-failure

Since a few months I have a build failure every time I try to generate
an initial ram file system (as my current primary workstation uses a
separate `/usr` and LVM for everything except `/boot`):

    * busybox: >> Compiling...
    * ERROR: Failed to compile the "all" target...
    * 
    * -- Grepping log... --
    * 
    *           - busybox-1.7.4-signal-hack.patch
    * busybox: >> Configuring...
    *COMMAND: make -j2 CC="gcc" LD="ld" AS="as"  
    *  HOSTCC  scripts/basic/fixdep
    *make: execvp: /var/tmp/genkernel/18562.2920.28766.17301/busybox-1.20.2/scripts/gen_build_files.sh: Permission denied
    *make: *** [gen_build_files] Error 127
    *make: *** Waiting for unfinished jobs....
    */bin/sh: scripts/basic/fixdep: Permission denied
    *make[1]: *** [scripts/basic/fixdep] Error 1
    *make: *** [scripts_basic] Error 2

I know it isn't SELinux that is causing this, as I have no denial
messages and even putting SELinux in permissive mode doesn't help. Today
I found the time to look at it with more fresh eyes, and noticed that it
wants to execute a file (`gen_build_files.sh`) situated in `/var/tmp`
somewhere. That file system however is mounted with `noexec` (amongst
other settings) so executing anything from within that file system is
not allowed.

The solution? Update `/etc/genkernel.conf` and have `TMPDIR` point to a
location where executing *is* allowed. Of course, this being a SELinux
system, the new location will need to be labeled as `tmp_t` as well, but
that's just a simple thing to do.

    ~# semanage fcontext -a -t tmp_t /var/build/genkernel(/.*)?
    ~# restorecon -R /var/build/genkernel

The new location is not world-writable (only for root as only root
builds initial ram file systems here) so not having `noexec` here is ok.
