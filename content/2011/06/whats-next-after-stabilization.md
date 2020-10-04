Title: What's next after stabilization?
Date: 2011-06-13 20:46
Category: Gentoo 
Slug: whats-next-after-stabilization

The last few weeks have shown quite a few interesting improvements on
Gentoo Hardened's SELinux state. We now have improved (simplified)
Gentoo profile support, supporting SELinux on no-multilib (an often
requested feature, now finally in), we stabilized the 2.20101213
policies that are in the tree and are cleaning up the old ones. The
documentation is continuously updated
([handbook](http://www.gentoo.org/proj/en/hardened/selinux/selinux-handbook.xml)
and [FAQ](http://www.gentoo.org/proj/en/hardened/selinux-faq.xml)) and
we are getting a nice stream of users helping out and reporting stuff on
SELinux.

So, besides the further stabilization and bug fixing, what else is on
the horizon?

Well, our first concern now will be to make the ebuilds more... correct.
Some of them still violate a few QA rules and this needs to be fixed. If
possible, we'll also start converting our ebuilds to a more recent EAPI.

Then, we will take a first stab at MCS within Gentoo Hardened. Our
primary concern here is support for the virtualization technologies
which, if SELinux-aware, are often using MCS to shield off running
guests from each other.

So interesting times are ahead. And of course, while we're at it, we'll
continue improving policies and submitting our own patches upstream.
