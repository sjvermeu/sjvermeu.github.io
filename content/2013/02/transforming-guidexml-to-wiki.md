Title: Transforming GuideXML to wiki
Date: 2013-02-12 20:12
Category: Gentoo
Tags: Gentoo, guidexml, stylesheet, wiki, xml, xsl
Slug: transforming-guidexml-to-wiki

The [Gentoo project](http://www.gentoo.org) has its own [official
wiki](https://wiki.gentoo.org) for some time now, and we are going to
use it more and more in the next few months. For instance, in the last
Gentoo Hardened meeting, we already discussed that most user-oriented
documentation should be put on the wiki, and I've heard that there are
ideas on moving Gentoo project pages at large towards the wiki. And also
for the regular [Gentoo
documentation](http://www.gentoo.org/doc/en/list.xml) I will be moving
those guides that we cannot maintain ourselves anymore easily towards
the wiki.

To support migrations of documents, I created a
[gxml2wiki.xsl](https://github.com/sjvermeu/small.coding/blob/master/gxml2docbook/gxml2wiki.xsl)
stylesheet. Such a stylesheet can be used, together with tools like
**xsltproc**, to transform GuideXML documents into text output
*somewhat* suitable for the wiki. It isn't perfect (far from it
actually) but at least it allows for a more simple migration of
documents with minor editing afterwards.

Currently, using it is as simple as invoking it against the GuideXML
document you want to transform:

    ~$ xsltproc gxml2wiki.xsl /path/to/document.xml

The output shown on the screen can then be used as a page. The following
things still need to be corrected manually:

-   Whitespace is broken, sometimes there are too many newlines. I had
    to make the decision to put in newlines when needed (which makes too
    many newlines) rather than a few newlines too few (which makes it
    more difficult to find where to add in).
-   Links need to be double/triple checked, but i'll try to fix that in
    later editions of the stylesheet
-   Commands will have "INTERNAL" in them - you'll need to move the
    commands themselves into the proper location and only put the
    necessary output in the pre-tags. This is because the wiki format
    has more structure than GuideXML in this matter, thus
    transformations are more difficult to write in this regard.

The stylesheet currently automatically adds in a link towards a Server
and security category, but of course you'll need to change that to the
proper category for the document you are converting.

Happy documentation hacking!
