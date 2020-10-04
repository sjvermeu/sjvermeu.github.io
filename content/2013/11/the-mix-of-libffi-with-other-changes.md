Title: The mix of libffi with other changes
Date: 2013-11-03 10:27
Category: Security
Tags: Gentoo, hardened, libffi, portage, selinux
Slug: the-mix-of-libffi-with-other-changes

I [once again](http://blog.siphos.be/2013/04/securely-handling-libffi/)
came across libffi. Not only does the libffi approach fight with SELinux
alone, it also triggers the TPE (Trusted Path Execution) protections in
grSecurity. And when I tried to reinstall Portage, Portage seemed to
create some sort of runtime environment in a temporary directory as
well, and SELinux wasn't up to allowing that either.

Let's first talk about a quick workaround for the libffi-with-TPE issue.
Because libffi wants to create executable files in a world-writable
directory and then execute that file (try finding the potential security
issue here) TPE is prohibiting the execution. The easiest workaround is
to add the `portage` Linux user, as well as the Linux accounts that you
use to run emerge with (even just things like **emerge --info**) in the
`wheel` group. This group is exempt from TPE protections (unless you
configured a different group in your kernel for this:

    ~# zgrep CONFIG_GRKERNSEC_TPE_TRUSTED_GID /proc/config.gz
    CONFIG_GRKERNSEC_TPE_TRUSTED_GID=10

Next we also need to allow the `portage_t` domain to execute files
labeled with `portage_tmpfs_t`. You can do this by creating your own
SELinux policy module with the following content (or use selocal):

    can_exec(portage_t, portage_tmpfs_t)

This works around the libffi issue for now. A better solution still has
to be implemented (as discussed in the previous post).

With regards to the portage installation failing, you'll notice this
quickly when you get an error like so:

    ~# emerge -1 portage
    Calculating dependencies  ... done!
    Traceback (most recent call last):
      File "/usr/bin/emerge", line 50, in <module>
        retval = emerge_main()
      File "/usr/lib64/portage/pym/_emerge/main.py", line 1031, in emerge_main
        return run_action(emerge_config)
      File "/usr/lib64/portage/pym/_emerge/actions.py", line 4062, in run_action
        emerge_config.args, spinner)
      File "/usr/lib64/portage/pym/_emerge/actions.py", line 453, in action_build
        retval = mergetask.merge()
      File "/usr/lib64/portage/pym/_emerge/Scheduler.py", line 946, in merge
        rval = self._handle_self_update()
      File "/usr/lib64/portage/pym/_emerge/Scheduler.py", line 316, in _handle_self_update
        _prepare_self_update(self.settings)
      File "/usr/lib64/portage/pym/portage/package/ebuild/doebuild.py", line 2326, in _prepare_self_update
        shutil.copytree(orig_bin_path, portage._bin_path, symlinks=True)
      File "/usr/lib64/portage/pym/portage/__init__.py", line 259, in __call__
        rval = self._func(*wrapped_args, **wrapped_kwargs)
      File "/usr/lib64/python3.3/shutil.py", line 343, in copytree
        raise Error(errors)
    shutil.Error: [(b'/usr/lib64/portage/bin/ebuild-helpers/prepalldocs', 
    b'/var/tmp/portage/._portage_reinstall_.osj370/bin/ebuild-helpers/prepalldocs', 
    "[Errno 13] Permission denied: '/var/tmp/portage/._portage_reinstall_.osj370/bin/ebuild-helpers/prepalldocs'"), 
    (b'/usr/lib64/portage/bin/ebuild-helpers/prepinfo', 
    b'/var/tmp/portage/._portage_reinstall_.osj370/bin/ebuild-helpers/prepinfo', 
    "[Errno 13] Permission denied: '/var/tmp/portage/._portage_reinstall_.osj370/bin/ebuild-helpers/prepinfo'"), 
    (b'/usr/lib64/portage/bin/ebuild-helpers/newlib.so', 
    b'/var/tmp/portage/._portage_reinstall_.osj370/bin/ebuild-helpers/newlib.so', 
    "[Errno 13] Permission denied: '/var/tmp/portage/._portage_reinstall_.osj370/bin/ebuild-helpers/newlib.so'"), 
    [...]

And the errors go on and on and on.

I've been able to get it working again by allowing the following SELinux
permissions:

    allow portage_t portage_tmp_t:dir relabel_dir_perms;
    allow portage_t portage_tmp_t:lnk_file relabel_lnk_file_perms;
    allow portage_t bin_t:dir relabel_dir_perms;
    allow portage_t bin_t:file relabel_file_perms;
    allow portage_t bin_t:lnk_file relabel_lnk_file_perms;
    allow portage_t portage_exec_t:file relabel_file_perms;
    allow portage_t portage_fetch_exec_t:file relabel_file_perms;
    allow portage_t lib_t:dir relabel_dir_perms;
    allow portage_t lib_t:file relabel_file_perms;

You can somewhat shorten this by combining types (but this doesn't work
with selocal for now):

    allow portage_t { portage_tmp_t bin_t lib_t}:dir relabel_dir_perms;
    allow portage_t { portage_tmp_t bin_t }:lnk_file relabel_lnk_file_perms;
    allow portage_t { bin_t portage_exec_t portage_fetch_exec_t lib_t}:file relabel_file_perms;

At the end of the emerge process (when the new portage is installed) you
might want to reset the labels of all files provided by the portage
package:

    ~# rlpkg portage

These changes have not been passed into the policy yet as I first need
to find out why exactly they are needed, and as you can see from [the
gentoo devaway](http://dev.gentoo.org/devaway/) page, time is not on my
side to do this. I'll try to free up some time in the next few days to
handle this as well as the [SELinux userspace
release](http://userspace.selinuxproject.org/trac/wiki/Releases) but no
promises here.

*Edit:* I found why - it is the `_prepare_self_update` in the
`doebuild.py` script. It creates temporary copies of the Portage
binaries and Portage python libraries, which is why we need to support
relabel operations on the files. Support for this is now in the policy
repository.

</p>

