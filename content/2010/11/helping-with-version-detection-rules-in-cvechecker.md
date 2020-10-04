Title: Helping with version detection rules in cvechecker
Date: 2010-11-27 17:59
Category: Security
Slug: helping-with-version-detection-rules-in-cvechecker

The new development snapshot, available from the [cvechecker project
site](http://cvechecker.sourceforge.net), contains a helper script that
returns potential version detection rules for your system if the current
cvechecker database doesn't detect your software. The script is
currently available for Gentoo (called **cverules\_gentoo**) but other
distributions can be easily added. The actual logic for detection is
distribution-agnostic (the script **cvegenversdat**) so it shouldn't be
too much of a problem for other distributions to be supported as well.

Note that the script isn't very fast (it's not intended to be) nor has a
very high accuracy rate. After all, it does use generic regular
expressions to try. The idea is that deployments on systems that have
software I don't have on my system can help me with the development of
the version detection rules by sending me the output of the helper
script.

Next up: tool to auto-generate (part of) the acknowledgements file for
reporting purposes - getting information from distribution-specific
information. Once that is in, I'll tag it version 2.0 of cvechecker.
