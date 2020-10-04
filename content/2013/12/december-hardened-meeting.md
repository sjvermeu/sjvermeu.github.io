Title: December hardened meeting
Date: 2013-12-20 10:20
Category: Gentoo
Tags: Gentoo, hardened, irc, meeting, online
Slug: december-hardened-meeting

Yesterday evening (UTC, that is) the members of the [Gentoo
Hardened](https://wiki.gentoo.org/wiki/Project:Hardened) project filled
the \#gentoo-hardened IRC channel again - it was time for another online
follow-up meeting.

*Toolchain*

A few patches on the toolchain need to be created to mark SSP as
default, but this is just a minor workload.

And on the [ASAN (Address
Sanitizer)](http://code.google.com/p/address-sanitizer/) debacle;
well... still the same. Doesn't work with PaX. I think there is a
standstill on this.

*Kernel, grsecurity/PaX*

It is not clear yet what the next LTS (Long Term Stable) kernel will be
that the [grSecurity](https://grsecurity.net/) team will support. This
depends on the Ubuntu LTS support, and as it is not clear which kernel
that distribution will use for LTS, the grSecurity team can also not say
what kernel it will be. (So please stop asking ;-)

grsecurity 3.0 is out, with the following commit message:

    commit 4f48151d49f2697c3e2e108a50513a8d61fb150d
    Author: Brad Spengler 
    Date:   Sun Nov 24 17:47:14 2013 -0500

        Version bumped to 3.0 (we'd been on 2.9.1 for way too long and numerous
        features have been added since then)
        
        Introduce new atomic RBAC reload method, developed as part of sponsorship
        by EIG
        
        This is accompanied by an updated 3.0 gradm which will use the new reload
        method when -R is passed to gradm.  The old method will still be available
        via gradm -r (which is what a 2.9.1 gradm will continue to use).
        
        The new RBAC reload method is atomic in the sense that at no point in the
        reload process will the system not be covered by a coherent full policy.
        In contrast to previous reload behavior, it also preserves inherited subjects
        and special roles.
        
        The old RBAC reload method has also been made atomic.  Both methods have
        been updated to perform role_allowed_ip checks only against the IP tagged
        to the task at the time its role was first applied or changed.  This resolves
        long-standing usability problems with the use of role_allowed_ip and matches
        the policies created by learning.

The new version requires the use of `>=gradm-3.0`. Some hardened-sources
packages already contain the 3.0 patchset (currently in testing). In a
few days, a final hardened-sources with a 2.9.1 patchset will be
stabilized; after that, only 3.0 patchset sources will be used.

Another open issue (for a while) is the `install.py` wrapper used to
properly pax-mark binaries during package building (instead of
post-merge changes). Although it works functionally well, it has serious
performance regressions when hundreds of files need to be merged and
marked. For each file, the Python interpreter is launched again, making
this a very time-consuming effort. Blueness is currently working on a
C-based wrapper which should load much faster.

*SELinux*

The live repository of the Gentoo Hardened policies is well up to date
with the latest evolutions of the reference policy. If you want to use
these, use the `-9999` ebuilds for the SELinux policy packages. This can
be accomplished with the following line in
<path>package.accept\_keywords</path>:

    sec-policy/* **

Recently, revision 5 of the SELinux policies has been pushed to the tree
(currently in testing). This one also contains a few required changes to
the policy for the new userspace utilities which are also now available
in the tree. An important update on the new userspace utilities is that
they contain many of the patches we needed in Gentoo and of course the
necessary updates, patches and improvements all-round. Once the SELinux
policies are stabilized, the userspace utilities will be too.

After a few successful runs with SELinux on ARM devices, we will most
likely be tagging our SELinux packages (policies and userspace
utilities) as `~arm`. Documentation will need to be updated on this as
well, not only to cater for the additional keyword, but also because of
one (perhaps a few) changes needed, like fixing the SELinux binary
policy (as most ARM systems come with a lower kernel version).

SELinux support on ZFS also seems to work well, with the last patches in
(thanks to prometheanfire).

As a final aspect, the SELinux eclass in Gentoo Linux now also supports
fetching the latest policy sources from git through HTTP (instead of
git/ssh).

*Integrity*

Not much to discuss here; IMA/EVM and kernel signing all work well.

In the next few days/weeks, I will be working on a [Gentoo Security
Benchmark](http://dev.gentoo.org/~swift/docs/security_benchmarks/gentoo.html)
as a sort-of follow-up (improvement) of the current [Gentoo Security
Handbook](http://www.gentoo.org/doc/en/security/), now using SCAP
methods.

*Profiles*

There has been discussion about supporting a [hardened desktop
profile](http://www.gentoo.org/doc/en/security/) in Gentoo again. This
does come with the nasty surprise that these profiles don't play well
together, so a solution needs to be brought in place. This could be a
"hardened desktop" profile separate from the gentoo desktop one (and as
such manually synchronized), or an improved approach on profile
stacking.

One idea was to support stacking with a maximum depth, allowing to use
changes made by a profile without inheriting the changes that that
profile inherited to a certain extend.

Another idea is to use a more dependency-based syntax (similar to OpenRC
dependency system for init scripts), which not only allows for proper
stacking and the necessary flexibility, but also improves readability:

    before {
      hardened/linux/amd64
    }
    after {
      default/linux/amd64
    }
    depends {
      targets/desktop/gnome
    }

The next few months will be interesting to see how this will evolve ;-)

*Documentation*

All our documents are on the [wiki](https://wiki.gentoo.org), so if you
notice gaps or see possibilities for improvement - by all means, do
them.

All in all a good session. Thanks for the good work guys!
