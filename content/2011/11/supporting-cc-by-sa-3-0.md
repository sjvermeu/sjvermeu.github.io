Title: Supporting CC-BY-SA 3.0
Date: 2011-11-29 21:33
Category: Gentoo
Slug: supporting-cc-by-sa-3-0

Until now, documents on the [Gentoo website](http://www.gentoo.org) all
had to be licensed under the [Creative Commons Attribution/Share
Alike](https://creativecommons.org/licenses/by-sa/2.5/) license, version
2.5. Why? Because at the time of the license choice, that was probably
the latest version at hand. In the XML code itself, the license tagging
was done using a `<license />` tag. Simple and efficient. But things
change, and so do license versions.

The folks over at Creative Commons have released [version
3.0](https://creativecommons.org/licenses/by-sa/3.0/) somewhere in 2007.
I'm not going to cover the
[differences](https://creativecommons.org/weblog/entry/7249) here, but
in general, the principle behind Gentoo's choice for the CC-BY-SA
license remains. But we didn't change our licenses and there was no real
need for it either.

Recently however, the [Official Gentoo Wiki](http://wiki.gentoo.org) was
announced, which uses the CC-BY-SA license as well... but the 3.0
version of it. You can't blame them for taking the latest version, but
that does made it a bit more difficult to share resources between the
two repositories (wiki versus GuideXML-ified website). The solution?
Support CC-BY-SA 3.0 for GuideXML too.

A few commits in our repository made that change happen. Nothing big
though: the
[DTD](http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo/xml/htdocs/dtd/common.dtd?sortby=date&r1=1.4&view=log)
is updated to allow for `<license version="3.0"/>` tags, the
[XSL](http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo/xml/htdocs/xsl/guide.xsl?sortby=date&r1=1.252&view=log)
is updated to support this attribute (and display the new license) and a
few other files (supporting files, like the [GuideXML
Guide](http://www.gentoo.org/doc/en/xml-guide.xml)) have received the
necessary updates.

The result of the change is that existing documents remain under the
current 2.5 license (we are not allowed to bump versions of licenses as
most documents are not copyrighted by Gentoo Foundation but by their
respective authors) but new documents can now use the 3.0 license.

*Edit:* Sebastian Pipping mailed me to say that in the legal code of the
CC-BY-SA 2.5 license there is a clausule about "... a later version of
this license with the same License elements...", so perhaps I might have
a "take two" on this.
