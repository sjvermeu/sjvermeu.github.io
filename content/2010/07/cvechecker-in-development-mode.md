Title: cvechecker in development mode
Date: 2010-07-12 20:31
Category: Security
Slug: cvechecker-in-development-mode

A while ago I had the idea to create a simple tool that checks the CVE
database against my current system. It would allow me to check if my
system is somewhat up to date (no pending security vulnerabilities), but
also to get an automated overview of the various software packages (and
versions) using a distribution-agnostic method.

So I started coding. The idea is to have a tool which can interprete CVE
data, gather current version information from the system and match the
CVEs against these versions and report the results to me.

I have created a [sourceforge](http://cvechecker.sourceforge.net)
project to host the source code and preliminary documentation for the
tool. Although the tool runs, it is still far from finished. On the
site, you can check out the progress of the development (there's a first
todo-list on the main page).

Do you think this is a good idea? I'd be happy to hear it.
