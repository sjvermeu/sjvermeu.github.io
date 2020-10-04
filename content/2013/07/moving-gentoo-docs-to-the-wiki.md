Title: Moving Gentoo docs to the wiki
Date: 2013-07-28 11:22
Category: Documentation
Tags: docs, documentation, gdp, Gentoo, wiki
Slug: moving-gentoo-docs-to-the-wiki

Slowly but surely Gentoo documentation guides are being moved to the
[Gentoo Wiki](https://wiki.gentoo.org). Thanks to the translation
support provided by the infrastructure, all "reasons" not to go forward
with this have been resolved. At first, I'm focusing on documentation
with open bugs that have not been picked up (usually due to (human)
resource limits), but other documents will follow.

Examples of already moved documents are the [Xorg configuration
guide](https://wiki.gentoo.org/wiki/Xorg/Configuration), the [GCC
optimization guide](https://wiki.gentoo.org/wiki/GCC_optimization),
[UTF-8](https://wiki.gentoo.org/wiki/UTF-8) and [System testing with
UML](https://wiki.gentoo.org/wiki/User-mode_Linux/System_testing_with_UML).
Many more have been moved as well.

The migrations are assisted by a conversion script that translates
GuideXML into wiki style content, although manual corrections remain
needed. For instance, all `<pre caption="...">` stuff is changed into
`{{Code|...}}` even though the Wiki has several templates for code, such
as `{{Kernel|...}}` for kernel configurations, `{{RootCmd|...}}` for
commands ran as a privileged user and `{{Cmd|...}}` for unprivileged
user commands.

I updated the [documentation
list](http://www.gentoo.org/doc/en/list.xml) on the main Gentoo site to
reflect the movement of documents as well, as this list will be slowly
shrinking.
