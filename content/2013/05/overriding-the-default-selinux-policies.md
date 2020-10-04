Title: Overriding the default SELinux policies
Date: 2013-05-15 03:50
Category: Gentoo
Tags: ebuild, epatch_user, Gentoo, override, patch, policy, selinux
Slug: overriding-the-default-selinux-policies

Extending SELinux policies with additional rules is easy. As SELinux
uses a *deny by default* approach, all you need to do is to [create a
policy
module](https://wiki.gentoo.org/wiki/SELinux/Tutorials/Creating_your_own_policy_module_file)
that contains the additional (allow) rules, load that and you're all
set. But what if you want to remove some rules?

Well, sadly, SELinux does not support deny rules. Once an allow rule is
loaded in memory, it cannot be overturned anymore. Yes, you can disable
the module itself that provides the rules, but you cannot selectively
disable rules. So what to do?

Generally, you can disable the module that contains the rules you want
to disable, and load a custom module that defines everything the
original module did, except for those rules you don't like. For
instance, if you do not want the `skype_t` domain to be able to
read/write to the video device, create your own skype-providing module
(*myskype*) with the exact same content (except for the module name at
the first line) as the original skype module, except for the video
device:

    dev_read_sound(skype_t)
    # dev_read_video_dev(skype_t)
    dev_write_sound(skype_t)
    # dev_write_video_dev(skype_t)

Load in this policy, and you now have the `skype_t` domain without the
video access. You will get post-install failures when Gentoo pushes out
an update to the policy though, since it will attempt to reload the
`skype.pp` file (through the `selinux-skype` package) and fail because
it declares types and attributes already provided (by *myskype*). You
can [exclude the
package](http://www.gentoo.org/doc/en/handbook/handbook-x86.xml?part=3&chap=5#doc_chap1)
from being updated, which works as long as no packages depend on it. Or
live with the post-install failure ;-) But there might be a simpler
approach: *epatch\_user*.

Recently, I added in support for *epatch\_user* in the policy ebuilds.
This allows users to create patches against the policy source code that
we use and put them in `/etc/portage/patches` in the directory of the
right category/package. For module patches, the working directory used
is within the `policy/modules` directory of the policy checkout. For
base, it is below the policy checkout (in other words, the patch will
need to use the `refpolicy/` directory base). But because of how
*epatch\_user* works, any patch taken from the base will work as it will
start stripping directories up to the fourth one.

This approach is also needed if you want to exclude rules from
interfaces rather than from the `.te` file: create a small patch and put
it in `/etc/portage/patches` for the `sec-policy/selinux-base` package
(as this provides the interfaces).
