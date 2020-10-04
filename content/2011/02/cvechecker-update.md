Title: cvechecker update
Date: 2011-02-19 16:31
Category: Security
Slug: cvechecker-update

A while ago, I got the request to enhance
[cvechecker](http://cvechecker.sourceforge.net) with support for
providing a list of installed software (or software you want to watch
over with cvechecker) even if cvechecker isn't able to detect that
software on your system. I've implemented this and it is currently
available in the SVN repository. The next release of cvechecker will
support this, but I'm hoping to add support for other databases with it
as well (currently, it uses a local sqlite database but I'm hoping to
support at least MySQL and postgresql too).
