Title: Aaaand we're back - hardened monthly meeting
Date: 2013-09-26 22:22
Category: Gentoo
Tags: hardened, irc, meeting
Slug: aaaand-were-back-hardened-monthly-meeting

It almost feels like we had our monthly online meeting just a week ago.
Below a small write-up of the highlights. If you want to know the gory
details, just wait a few hours/days until the IRC logs are sent out ;-)
Now remember, the project does more than what the highlights tell you -
there is lots of maintenance done "under the hood", allowing everyone to
keep using the various
[technologies](https://wiki.gentoo.org/wiki/Hardened/Introduction_to_Hardened_Gentoo)
supported through our project.

*Toolchain*

As per a discussion on the Gentoo development mailinglist, GCC 4.8 will
most likely have SSP enabled as default. Gentoo Hardened will still
enable full SSP (`-fstack-protector-all`) whereas Gentoo by default will
probably work with `-fstack-protector`). We will also still provide GCC
specifications that disable stack protection completely (the
`hardened-nossp` specs) for when developers or users need it.

*Kernel and grsec/PaX*

Blueness informed us about one issue with XATTR\_PAX implementation,
being the `install.py` wrapper that we need in order to set the right
attributes as early as possible. The problem is that it is very slow (as
it is invoked over and over again, so the overhead of it being an
interpreted script becomes huge). A solution for this still has to be
defined.

Some ideas are to use a compiled version, but other possible solutions
such as hooking into Portage directly or using lists have been suggested
as well.

*SELinux*

Nothing big - standard maintenance stuff, such as pushing our own
patches upstream for others to benefit (and hopefully have the master
projects include the patches so we don't need to maintain them
ourselves). Also, revision 3 of the 2.20130424 policies are now in the
tree (\~arch'ed for now).

*System Integrity*

Within Gentoo, we have a couple of SCAP scanners/software available,
such as open-scap and ovaldi. Recently, openscap-9999 is made available
(allowing users to directly use the latest openscap release) which is
used to validate and evaluate security benchmarks I am developing for
Gentoo and related services.

Next to the SCAP-related developments, a
[guide](https://wiki.gentoo.org/wiki/Signed_kernel_module_support) has
been put on the Gentoo wiki about using signed kernel modules.

*Profiles*

The hardened profiles have been updated to use EAPI-5 so we can benefit
from its features, such as improved multilib support.

*Documentation*

As I mentioned before, I'm working a bit on a [Gentoo Security
Benchmark](http://dev.gentoo.org/~swift/docs/security_benchmarks/) that
can be used with SCAP software. The sources are in the
[hardened-docs](http://git.overlays.gentoo.org/gitweb/?p=proj/hardened-docs.git;a=tree;f=xml/SCAP;hb=HEAD)
repository for now.

Also, most/all hardened documentation is moved from the
(developer-editable only) `Project:` namespace to the general one,
allowing users and contributors to help us with the documents as well.
