Title: Slowly converting from GuideXML to HTML
Date: 2015-08-25 11:30
Category: Gentoo
Tags: gentoo, guidexml, xml, xslt, rst, mediawiki, html
Slug: slowly-converting-from-guidexml-to-html

Gentoo has removed its support of the older GuideXML format in favor of using
the [Gentoo Wiki](https://wiki.gentoo.org) and a new content management system
for the main site (or is it static pages, I don't have the faintest idea to be
honest). I do still have a few GuideXML pages in my development space, which I
am going to move to HTML pretty soon.

In order to do so, I make use of the [guidexml2wiki](https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo/xml/htdocs/xsl/guidexml2wiki.xsl?view=log)
stylesheet I [developed](http://blog.siphos.be/2013/02/transforming-guidexml-to-wiki/).
But instead of migrating it to wiki syntax, I want to end with HTML.

<!-- PELICAN_END_SUMMARY -->

So what I do is first convert the file from GuideXML to MediaWiki with `xsltproc`.

Next, I use `pandoc` to convert this to restructured text. The idea is that the main
pages on my devpage are now restructured text based. I was hoping to use markdown, but
the conversion from markdown to HTML is not what I hoped it was.

The restructured text is then converted to HTML using `rst2html.py`. In the end,
I use the following function (for conversion, once):

```sh
# Convert GuideXML to RestructedText and to HTML
gxml2html() {
  basefile=${1%%.xml};

  # Convert to Mediawiki syntax
  xsltproc ~/dev-cvs/gentoo/xml/htdocs/xsl/guidexml2wiki.xsl $1 > ${basefile}.mediawiki

  if [ -f ${basefile}.mediawiki ] ; then
    # Convert to restructured text
    pandoc -f mediawiki -t rst -s -S -o ${basefile}.rst ${basefile}.mediawiki;
  fi

  if [ -f ${basefile}.rst ] ; then
    # Use your own stylesheet links (use full https URLs for this)
    rst2html.py  --stylesheet=link-to-bootstrap.min.css,link-to-tyrian.min.css --link-stylesheet ${basefile}.rst ${basefile}.html
  fi
}
```

Is it perfect? No, but [it works](http://dev.gentoo.org/~swift/snapshots/).

