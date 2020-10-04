Title: Darwin Information Typing Architecture
Date: 2009-04-18 09:59
Category: Documentation
Slug: darwin-information-typing-architecture

Having documented a lot in LaTeX (back in the old days at the
university), [GuideXML](http://www.gentoo.org/doc/en/xml-guide.xml)
(Gentoo's document markup language) and DocBook ([Linux
Sea](http://swift.siphos.be/linux_sea)) I'm now pointing my arrows at
DITA, the [Darwin Information Typing
Architecture](http://en.wikipedia.org/wiki/Darwin_Information_Typing_Architecture).

DITA "forces" the technical writer in separating the content of his
document in specialized subjects: reference, task or concept, or a
specialized version of any of those which you can create/define
yourself.

By separating content in those three subjects, you can more easily
manage your technical documentation (write concepts as individual
topics, tasks as end-user procedures and references for affiliated
topics or command information).

Once all these documents are written, you bind them together using a
DITA map (a metadocument which holds references to all related
concepts/tasks/references) et voila: your documentation is ready.

Well, not really, you need to build it to something end users can read -
you can use [dita-ot](http://dita-ot.sourceforge.net/) for that. It
supports building for Eclipse Infocenter, RTF, XHTML and PDF out of the
box.
