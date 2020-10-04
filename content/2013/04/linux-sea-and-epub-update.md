Title: Linux Sea and ePub update
Date: 2013-04-02 20:16
Category: Documentation
Tags: epub, linux sea, linux_sea
Slug: linux-sea-and-epub-update

I just "published" a small update on the [Linux
Sea](http://swift.siphos.be/linux_sea) online book. Nothing major, some
path updates (like the move to /etc/portage for the make.conf file). But
I wouldn't put a blog post online if there wasn't anything else to say
;-)

Recently I was made aware that the ePub versions I publish were broken.
I don't use ePub readers myself, so all I do is read the ePubs through a
Firefox plug-in and it's been a while that I did that on my own ePubs.
Apparently, the stylesheets I used to convert the Docbook to ePub
changes behavior (or my scripts abused an error in the previous
stylesheets that are fixed now). So right now the
[ePub](http://swift.siphos.be/linux_sea/linux_sea.epub) version should
work again, and the code snippet below is what I use now to build it:

    xsltproc --stringparam base.dir linuxsea-epub/OEBPS/ /usr/share/sgml/docbook/xsl-stylesheets/epub3/chunk.xsl LINUXSEA.xml;
    cp -r /path/to/src/linux_sea/images linuxsea-epub/OEBPS;
    cd linuxsea-epub;
    zip -X0 linux_sea.epub mimetype;
    zip -r -X9 linux_sea.epub META-INF OEBPS;
    mv linux_sea.epub ../;
