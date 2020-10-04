Title: Confining user applications
Date: 2011-01-16 16:23
Category: SELinux
Slug: confining-user-applications

Ever since I started using SELinux, I'm getting more and more fond of
what it can do for (security) administrators. Lately, I've started
confining user applications (like **skype**) in the idea that I do not
want any application connecting to the Internet or working with content
received from untrusted sources to work inside the main user domain
(`user_t` or `staff_t` in my case). This particular exercise has been
quite interesting, not only to learn more on SELinux, not only to get
acquainted with the reference policy which Gentoo basis its policies
upon. No, it's been interesting because you learn how applications work
underneith...

Take the skype application for example. Little did I know it read stuff
from my firefox configuration (like the `sec8.db` and `prefs.js` file),
most likely to see if the skype firefox plugin is installed. With
SELinux, I saw that it did all that - and also denied it. But it isn't
easy to find out why an application behaves as it does. After all, these
aren't questions that average joe asks. It also isn't easy to deduce if
you want to allow it or not. If it was purely for my own system, I
wouldn't hesitate for long, but the idea is that the modules should work
for the majority of people - and who knows, perhaps even be included in
the reference policy in the future.

Perhaps Gentoo Hardened can write up some rules on the SELinux policies
and how they should be made for the distribution. Do we want to deny as
much as possible, only allowing those things developers can safely
verify need to be allowed? Or do we want to allow everything that the
application already does (but nothing more) so that no AVC denials are
shown anymore? And if Gentoo Hardened chooses "deny as much as
possible", do we configure the policy to not audit those things we don't
think we need (hiding it) or do we expect the security administrator to
manage his own *dontaudit* rules? Well, guess I'll ask the hardened
folks and see what they think ;-)

During the quest, I'll try to update the [Gentoo Hardened SELinux
handbook
draft](http://git.overlays.gentoo.org/gitweb/?p=proj/hardened-docs.git;a=blob_plain;f=pdf/selinux-handbook.pdf;hb=HEAD).
It's far from finished, but should be usable for most interested
parties. If you're interested in SELinux and want to give it a try with
Gentoo Hardened, this might be the document you are looking for.
