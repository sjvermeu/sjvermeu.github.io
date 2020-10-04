Title: Switching to hardened
Date: 2010-09-12 13:41
Category: Gentoo
Slug: switching-to-hardened

Yesterday (and this night) I successfully converted my system to a
[Gentoo Hardened](http://hardened.gentoo.org) system. In my case, this
currently means that
[PaX](http://www.gentoo.org/proj/en/hardened/pax-quickstart.xml) has
been enabled and I am currently running the system (which is an x86\_64
laptop) with [SELinux](http://www.gentoo.org/proj/en/hardened/selinux/)
in permissive mode (so it won't enforce the policies yet, but report
violations so I can see in my logs if enforcement is possible or not).
The permissive mode will be on for quite some time I would assume, as
getting SELinux active on the system involved quite a few \~amd64
packages and I'm not too fond of using that branch (I'm more of a
stability guy).
