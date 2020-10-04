Title: Listing files of (not) installed software
Date: 2010-06-05 10:54
Category: Gentoo
Tags: gentoo
Slug: listing-files-of-not-installed-software

Everyone that has been using Gentoo for a while now knows about tools
such as **qlist** that show you the list of files installed by an
(installed) package, or **qfile** that allows you to find which package
provided a particular file on your system.

One thing lacking is to be able to find out which package *would*
provide a file. Unlike the previous tools, this tool cannot rely on the
information found on your system as the package isn't installed yet.

There have been projects in the past that attempted to provide such
functionality, almost always through an online queryable database. Many
haven't survived, due to too high expectations or little server
infrastructure resources. But it seems like
[PortageFileList](http://www.portagefilelist.de) is to stay for a while.

The project not only offers an online interface for querying
information, it also provides a package (`app-portage/pfl`) that allows
you to query their infrastructure from the command line. The package
provides a tool called **e-file** which supports SQL-like syntax for the
queries.

` ~$ e-file '%bin/xdm'`

The above command will then display, using the well-known emerge/Portage
output, which package provides the file (as well as which file was
matched by the query).

Definitely a nice tool to have around. Thanks guys of
[PortageFileList](http://www.portagefilelist.de)!
