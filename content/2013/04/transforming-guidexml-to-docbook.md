Title: Transforming GuideXML to DocBook
Date: 2013-04-20 03:50
Category: Gentoo
Tags: docbook, Gentoo, guidexml, pdf, xsl
Slug: transforming-guidexml-to-docbook

I recently
[committed](http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo/xml/htdocs/xsl/docbook.xsl?sortby=date&view=log)
an XSL stylesheet that allows us to transform the GuideXML documents
(both guides and handbooks) to DocBook. This isn't part of a more
elaborate move to try and push DocBook instead of GuideXML for the
Gentoo Documentation though (I'd rather direct documentation development
more to the Gentoo wiki instead once translations are allowed): instead,
I use it to be able to generate our documentation in other formats (such
as PDF but also ePub) when asked.

If you're not experienced with XSL: XSL stands for *Extensible
Stylesheet Language* and can be seen as a way of "programming" in XML. A
stylesheet allows developers to transform one XML document towards
another format (either another XML, or as [text-like output like
wiki](http://blog.siphos.be/2013/02/transforming-guidexml-to-wiki/))
while manipulating its contents. In case of documentation, we try to
keep as much structure in the document as possible, but other uses could
be to transform a large XML with only a few interesting fields towards a
very small XML (only containing those fields you need) for further
processing.

For now (and probably for the foreseeable future), the stylesheet is to
be used in an offline mode (we are not going to provide auto-generated
PDFs of all documents) as the process to convert a document from
GuideXML to DocBook to XML:FO to PDF is quite resource-intensive. But
users that are interested can use the stylesheet as linked above to
create their own PDFs of the documentation.

Assuming you have a checkout of the Gentoo documentation, this process
can be done as follows (example for the AMD64 handbook):

    $ xsltproc docbook.xsl /path/to/handbook-amd64.xml > /somewhere/handbook-amd64.docbook
    $ cd /somewhere
    $ xsltproc --output handbook-amd64.fo --stringparam paper.type A4   
     /usr/share/sgml/docbook/xsl-stylesheets/fo/docbook.xsl handbook-amd64.docbook
    $ fop handbook-amd64.fo handbook-amd64.pdf

The docbook stylesheets are offered by the
*app-text/docbook-xsl-stylesheets* package whereas the **fop** command
is provided by *dev-java/fop*.

I have an example output available (temporarily) at my [dev space (amd64
handbook)](http://dev.gentoo.org/~swift/tmp/handbook-amd64.pdf) but I'm
not going to maintain this for long (so the link might not work in the
near future).
