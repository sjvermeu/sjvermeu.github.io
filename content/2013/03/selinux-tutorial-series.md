Title: SELinux tutorial series
Date: 2013-03-15 00:34
Category: SELinux
Tags: articles, documentation, Gentoo, hardened, selinux, tutorials, wiki
Slug: selinux-tutorial-series

As we get a growing number of SELinux users within Gentoo Hardened and
because the SELinux usage at the firm I work at is most likely going to
grow as well, I decided to join the bunch of documents on SELinux that
are "out there" and start a series of my own. After all, too much
documentation probably doesn't hurt, and SELinux definitely deserves a
lot of documentation.

I decided to use the [Gentoo Wiki](https://wiki.gentoo.org) for this
endeavour instead of a GuideXML approach (which is the format used for
Gentoo documentation on the main site). The set of tutorials that I
already wrote can be found under the
[SELinux](https://wiki.gentoo.org/wiki/SELinux) : [Gentoo Hardened
SELinux Tutorials](https://wiki.gentoo.org/wiki/SELinux/Tutorials)
location. Although of course meant to support the Gentoo Hardened
SELinux users, I'm hoping to keep the initial set of tutorial articles
deliberately distribution-independent so I can refer to them at work as
well.

For now (this is a week's work, so don't expect this amount of tutorials
to double in the next few days) I wrote about the security context of a
process, how SELinux controls file and directory accesses, where to find
SELinux permission denial details, controlling file contexts yourself
and how a process gets into a certain context.

I hope I can keep the articles in good shape and with a gradual step-up
in complexity. That does mean that most articles are not complete (for
instance, when talking about domain transitions, I don't talk about
constraints that might prohibit them, or about the role and type
mismatches (invalid context) that you might get, etc.) and that those
details will follow in later articles. Hopefully that allows users to
learn step by step.

At the end of each tutorial, you will find a "What you need to remember"
section. This is a very short overview of what was said in the tutorial
and that you will need to know in future articles. If you ever read a
tutorial article, then this section might be sufficient for you to
remember again what it was about - no need to reread the entire article.

Consider it an attempt at a `tl;dr` for articles ;-) Enjoy your reading,
and if you have any remarks, don't hesitate to contribute on the wiki or
talk through the "Talk" pages.
