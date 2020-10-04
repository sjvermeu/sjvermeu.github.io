Title: cvechecker 0.1 released
Date: 2010-08-14 22:03
Category: Security
Slug: cvechecker-0-1-released

cvechecker [version
0.1](https://sourceforge.net/projects/cvechecker/files/) is out. This is
the first publicly available development release, so it's still far from
production-ready yet. However, it is usable so it can now be publicly
analyzed to remove all icky bugs and such. I'm not planning (m)any new
features (apart from the reporting script as mentioned on the tools'
[homepage](http://cvechecker.sourceforge.net)) before the first general
available release, but any request will be gladly documented and taken
in scope in future versions.

What is cvechecker? Well, it is a tool that strives to scan your system
for installed software. For each software it detects, it attempts to
discover which version you have. This information is stored in a local
database. The tool then matches this information with the (publicly
available) CVE data (security vulnerability information). If a CVE entry
mentions the software/version you have, the tool will report this to
you.

Who needs cvechecker? Noone needs it, but it can be interesting
nevertheless. Users that install lots of software themselves and don't
use the Linux distribution's package manager might benefit from this as
the tool will then help them verify if a security update is needed or
not. Users of [LinuxFromScratch](http://www.linuxfromscratch.org) can do
some security validation tests on their installations. Developers of
particular packages (or even tools) can use the tool to be notified when
one of their software's has a CVE (which most likely results in a new
version of the software to be made available).

Who needs cvechecker? No, this is not a duplicate paragraph - cvechecker
needs input. Most of the work goes in detecting the available software
and version. The method cvechecker uses is very rudimentary: run a
(predefined) regular expression against the file (which is parsed with
the **strings** command as this command understands ELF structures) and
if the expression matches, it will extract the version (which is found
using the expressions' groups) and store this in the database. The rules
are defined in the `versions.dat` file (also available from
[sourceforge](https://sourceforge.net/projects/cvechecker/files/)), but
this file is currently microscopicly filled - so lots and lots of
additional rules need to be added. I'll be adding more and more rules as
I encounter them (or have immediate need for), but I can definitely use
additional help here.

If you are interested in enhancing the `versions.dat` file, check out
the cvechecker manual page - it describes the format and how it is used
as well as some examples.

And yes, an ebuild is available in my
[overlay](http://github.com/sjvermeu/gentoo.overlay), but I'm no ebuild
developer (it's just easy to have them so Portage can track it) and the
ebuild is butt-ugly (and probably also violates all QA policies).
