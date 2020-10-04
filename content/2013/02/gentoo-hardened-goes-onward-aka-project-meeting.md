Title: Gentoo Hardened goes onward (aka project meeting)
Date: 2013-02-07 23:40
Category: Gentoo
Tags: Gentoo, grsecurity, hardened, kernel, meeting, minutes, online, pax, profiles, selinux
Slug: gentoo-hardened-goes-onward-aka-project-meeting

It's been a while again, so time for another Gentoo Hardened online
progress meeting.

*Toolchain*

GCC 4.8 is on development stage 4, so the hardened patches will be
worked on next week. Some help on it is needed to test the patches on
ARM, PPC and MIPS though. For those interested, keep a close eye on the
hardened-dev overlay as those will contain the latest fixes. When GCC
4.9 starts development phase 1, Zorry will again try to upstream the
patches.

With the coming fixes, we might probably (need to) remove the various
hardenedno\* GCC profiles from the hardened Gentoo profiles. This
shouldn't impact too many users as ebuilds add in the correct flags
anyhow (for instance when needing to turn off PIE/PIC).

*Kernel, grSecurity and PaX*

The kernel release 3.7.0 that we have stable in our tree has seen a few
setbacks, but no higher version is stable yet (mainly due to the
stabilization period needed). 3.7.4-r1 and 3.7.5 are prime candidates
with good track record,  
so we might be stabilizing 3.7.5 in the very near future (next week
probably).

On the PaX flag migration (you know, from ELF-header based marking to
extended attributes marking), the documentation has seen its necessary
upgrades and the userland utilities have been updated to reflect the use
of xattr markings. The eclass we use for the markings will use the
correct utility based on the environment.

One issue faced when trying to support both markings is that some
actions (like the "paxctl -Cc" which creates the PT\_PAX header if it is
missing) make no sense with the other (as there is no header when using
XATTR\_PAX). The eclass will be updated to ignore these flags when
XATTR\_PAX is selected.

*SELinux*

Revision 10 is stable in the tree, and revision 11 is waiting
stabilization period. A few more changes have been put in the policy
repository already (which are installed when using the live ebuilds) and
will of course be part of  
revision 12.

A change in the userland utilities was also pushed out to allow
permissive domains (so run a single domain in permissive mode instead of
the entire system).

Finally, the SELinux eclass has been updated to remove SELinux modules
from all defined SELinux module stores if the SELinux policy package is
removed from the system. Before that, the user had to remove the modules
from the store himself manually, but this is error-prone and easily
forgotten, especially for the non-default SELinux policy stores.

*Profiles*

All hardened subprofiles are marked as deprecated now (you've seen the
discussions on this on the mailinglist probably on this) so we now have
a sane set of hardened profiles to manage. The subprofiles were used for
things like  
"desktop" or "server", whereas users can easily stack their profiles as
they see fit anyhow - so there was little reason for the project to
continue managing those subprofiles.

Also, now that Gentoo has released its 13.0 profile, we will need to
migrate our profiles to the 13.0 ones as well. So, the idea is to
temporarily support 13.0 in a subprofile, test it thoroughly, and then
remove the subprofile and switch the main one to 13.0.

*System Integrity*

The documentation for IMA and EVM is available on the Gentoo Hardened
project site. They currently still refer to the IMA and EVM subsystems
as development-only, but they are available in the stable kernels now.
Especially the default policy that is available in the kernel is pretty
useful. When you want to consider custom policies (for instance with
SELinux integration) you'll need a kernel patch that is already
upstreamed but not applied to the stable kernels yet.

To support IMA/EVM, a package called ima-evm-utils is available in the
hardened-dev overlay, which will be moved to the main tree soon.

*Documentation*

As mentioned before, the PaX documentation has seen quite a lot of
updates. Other documents that have seen updates are the Hardened FAQ,
Integrity subproject and SELinux documentation although most of them
were small changes.

Another suggestion given is to clean up the Hardened project page;
however, there has been some talk within Gentoo to move project pages to
the Gentoo wiki. Such a move might make the suggestion easier to handle.
And while on the subject of the wiki, we might want to move user guides
to the wiki already.

*Bugs*

Bug [443630](https://bugs.gentoo.org/443630) refers to segmentation
faults with libvirt when starting Qemu domains on a SELinux-enabled
host. Sadly, I'm not able to test libvirt myself so either someone with
SELinux and libvirt  
expertise can chime in, or we will need to troubleshoot it by bug
(using gdb, strace'ing more, ...) which might take quite some time and
is not user friendly...

*Media*

Various talks where held at FOSDEM regarding Gentoo Hardened, and a lot
of people attended those talks. Also the round table was quite
effective, with many users interacting with developers all around. For
next year, chances are very high that we'll give a "What has changed
since last year" session and a round table again.

With many thanks to the usual suspects: Zorry, blueness, prometheanfire,
lejonet, klondike and the several dozen contributors that are going to
kill me for not mentioning their (nick)names.
