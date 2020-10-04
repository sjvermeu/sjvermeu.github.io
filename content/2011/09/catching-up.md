Title: Catching up
Date: 2011-09-18 16:51
Category: Gentoo
Slug: catching-up

As
[mentioned](http://archives.gentoo.org/gentoo-doc/msg_f6d85b4b80e2e147fa09cf669b936b46.xml)
on the gentoo-doc mailinglist, all documentation bugs (that we know of)
related to openrc have been fixed. It was already a week like so, but
the last dependency on our "tracker" bug was an open one (asking if more
needs to be done or not) from which we haven't received an answer in
over a month. So I guess we're there.

Now, the OpenRC transition wasn't an easy one documentation-wise. Since
there is no full backwards compatibility, all changes would need to be
done in an atomic way, but due to resource constraints, the
documentation couldn't catch up on the changes in due time. Luckily,
that's over now and we can hopefully start by improving our
documentation once again.

For [SELinux](http://hardened.gentoo.org/selinux) too, OpenRC hasn't
been a gift. The latest `selinux-base-policy` now in the Portage tree
(20110726-r4) still includes some fixes to get OpenRC support fully
working. However, I'm fairly confident that we will be able to tackle
other bugs (if they arise) quickly now, since the basic policy
definitions (like support for `rc_exec_t`) are now in place.

With the major changes done, let's look at the future. For
documentation, I'm now working on a new [Power Management
Guide](http://dev.gentoo.org/~swift/docs/previews/power-management-guide.xml)
whereas for SELinux, I'll be focusing on the remaining bugs as well as
documentation updates (the [SELinux
Handbook](http://hardened.gentoo.org/selinux/selinux-handbook.xml) will
have some major updates in the hope it becomes more useful and
future-proof). Also, for GDP, I'm going to make a suggestion towards the
[Gentoo Documentation
Policy](http://www.gentoo.org/proj/en/gdp/doc/doc-policy.xml), taking
into account that the GDP resources are not as high as at the time the
policy was written. Finally, I'm going to update my [installation
scripts](https://github.com/sjvermeu/small.coding/tree/HEAD/gensetup)
that I use to seed the virtual servers so that I can enhance the SELinux
policy testing.

I consider this post to be a checklist - after all, now that I promised
that I would do that, I guess I can't excuse myself from that anymore do
I ;-)
