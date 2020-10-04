Title: This months' stabilization done, more to come
Date: 2012-01-29 13:33
Category: Gentoo
Slug: this-months-stabilization-done-more-to-come

A small notification to tell you that the SELinux policies that were
pushed to the main tree 30 days (or more) ago have now been stabilized
(none of them introduced problems, although some of them have other bugs
still open which are either fixed in \~arch or will be fixed in the
hardened-dev overlay soon). I'll be working on pushing an additional set
of changes to hardened-dev overlay today as it includes fixes for openrc
that are quite important, and might even push this to the tree faster
than usual.

The reference policy is also working on a new release, so the moment it
is released we will be picking that up as well (give or take a month,
since my availability will be a bit less the next month).
