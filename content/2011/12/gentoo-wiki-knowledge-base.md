Title: Gentoo WiKi & Knowledge Base
Date: 2011-12-26 20:01
Category: Gentoo
Slug: gentoo-wiki-knowledge-base

I have been playing with the [Gentoo Wiki](http://wiki.gentoo.org) the
last few days and am very impressed with the work that both the wiki
teams as well as existing contributors have already done to the place.
The look and feel is very slick and editing works just as expected. One
of the changes I made was to move [SELinux module
information](http://wiki.gentoo.org/wiki/SELinux) to the wiki. This
documentation was originally intended to be published on the [Gentoo
SELinux Project](http://hardened.gentoo.org/selinux/) page, but is
easily accessible and maintainable on the wiki too.

So I went a step further and dug up my original [GLEP 0051 - Gentoo
Knowledge Base](http://www.gentoo.org/proj/en/glep/glep-0051.html)
proposal and checked how far I could use the Gentoo WiKi for this
purpose. From the looks of it, the WiKi can offer a great deal of
leverage for this idea and although not everything is supported through
the WiKi (like natural search language and such), that might have been
overshooting a bit. So we received a [Gentoo WiKi Knowledge
Base](http://wiki.gentoo.org/wiki/Knowledge_Base:Main_Page) namespace
under which the [Knowledgebase
entries](http://wiki.gentoo.org/index.php?title=Special%3AAllPages&from=&to=&namespace=500)
can reside.

Now what is the idea behind such a knowledge base? Well, first of all,
the articles below this prefix should all follow the same structure (as
explained in the [main
page](http://wiki.gentoo.org/wiki/Knowledge_Base:Main_Page)) and be
sufficiently specific so that the title of the entry should leave little
room for misinterpretation. But other than that, there is no limit as to
what the Knowledge Base could hold. To that respect, the knowledge base
section then provides a (hopefully) thorough listing of common and less
common issues with a good explanation why the problem occurred and how
to resolve it.

For the time being, the location doesn't hold that many
[entries](http://wiki.gentoo.org/index.php?title=Special%3AAllPages&from=&to=&namespace=500)
yet, but I will add them as they come along. And of course, feedback is
always appreciated ;-)

On a second note, I'd like to give my PoV on the wiki and its relation
with the official Gentoo documentation. Unlike what might be
circulating, I'm definitely not against the wiki for documentation, on
the contrary. Wiki's have proven to be a good resource for
documentation, and because we can never have enough documentation
writers, every method for getting more documentation is welcome. But
because of its online nature, offline documentation development (which I
frequently do) is not possible. Also, keeping translations in sync might
be a bit more challenging compared to a file-based solution with version
control (otoh, I have little experience with WiKi translations so I
might be wrong here).

I strongly believe that the wiki will play a big role in Gentoo's
documentation assets. Many of the documents currently managed by the GDP
or the subprojects might be suited to be hosted on the WiKi, especially
when those documents are too specific (and as such would require a very
specific developer profile to maintain the documents). In such cases,
the maintainers of those documents should be able to pick the most
efficient method. But for very generic documents, this might not be an
easy option.

At least the Gentoo documents now support CC-BY-SA 3.0, so we can
migrate documents from the wiki to the main site, and the 2.5 version
currently used the most on the main site should be forward compatible
with 3.0 (if I read the legalese text well) so we might be able to
migrate documents from the main site to the wiki too.

*Edit:* a3li created the "Knowledge Base" namespace on the wiki, so I
updated the links in my post. Thanks for the work on the wiki, a3li!
