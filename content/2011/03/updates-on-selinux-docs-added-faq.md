Title: Updates on SELinux docs, added FAQ
Date: 2011-03-09 22:17
Category: SELinux
Slug: updates-on-selinux-docs-added-faq

As you're probably noticing from my [twitter
feed](https://twitter.com/#!/sjvermeu) and the various posts earlier in
my blog, I'm helping out with the Gentoo Hardened folks to get the
SELinux support state up to par. Today, the [Gentoo Hardened/SELinux
Handbook](http://goo.gl/DlHJD) had a few updates, but the most important
change is that there is now a [Gentoo Hardened SELinux
FAQ](http://goo.gl/uaaf4) (in draft). I'm hoping that, at the next IRC
meeting, we can vote on having it pushed to the main site. Also, the
latest changes I made to various SELinux policy ebuilds have been pushed
to the main tree.

I'm now focusing on running various servers in KVM guests to test the
SELinux policies. Following the [Gentoo Virtual Mailhosting
HOWTO](http://www.gentoo.org/doc/en/virt-mail-howto.xml) creates a
working system, although a few SELinux-specific steps had to be added
(if you follow the guide exactly to the letter, you won't finish it).
The issues are minor though: `selinux-sasl` needs to be installed
manually (it isn't pulled in as a dependency), the PIDFILE and
SSLPIDFILE variables in /etc/courier-imap/\* need to point to
/var/run/courier (and that location needs to be created) to match the
file context definitions as suggested by upstream, you need to run
**postalias /etc/mail/aliases** instead of **newaliases** and during the
installation of Apache, you might need to **chcon -t bin\_t
/usr/share/build-1/mkdir.sh** as you'll get a permission denied
otherwise.
