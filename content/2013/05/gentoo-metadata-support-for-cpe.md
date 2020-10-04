Title: Gentoo metadata support for CPE
Date: 2013-05-10 03:50
Category: Gentoo
Tags: cpe, cve, Gentoo, metadata, security
Slug: gentoo-metadata-support-for-cpe

Recently, the `metadata.xml` file syntax definition (the DTD for those
that know a bit of XML) has been updated to support CPE definitions. A
[CPE](https://nvd.nist.gov/cpe.cfm) (Common Platform Enumeration) is an
identifier that
[describes](http://cpe.mitre.org/specification/index.html) an
application, operating system or hardware device using its vendor,
product name, version, update, edition and language. This CPE
information is used in the CVE releases (Common Vulnerabilities and
Exposures) - announcements about vulnerabilities in applications,
operating systems or hardware. Not all security vulnerabilities are
assigned a CVE number, but this is as close as you get towards a
(public) elaborate dictionary of vulnerabilities.

By allowing Gentoo package maintainers to enter (part of) the CPE
information in the `metadata.xml` file, applications that parse the CVE
information can now more easily match if software installed on Gentoo is
related to a CVE. I had a [related
post](http://blog.siphos.be/2013/04/matching-packages-with-cves/) to
this not that long ago on my blog and I'm glad this change has been
made. With this information at hand, we can start feeding CPE
information to the packages and then easily match this with CVEs.

I had a request to "provide" the scripts I used for the previous post.
Mind you, these are taking too many assumptions (and probably wrong
ones) for now (and I'm not really planning on updating them as I have
different methods for getting information related to CVEs), but I'm
planning on integrating CPE data in Gentoo's packages more and then
create a small script that generates a "watchlist" that I can feed to
[cvechecker](http://cvechecker.sourceforge.net). But anyway, here are
the scripts.

[First](http://dev.gentoo.org/~swift/blog/01/0_createcve.txt), I took
all CVE information and put it in a simple CSV file. The CSV is the same
one used by cvechecker, so check out the application to see where it
fetches the data from (there is a CVE RSS feed and a simple XSL
transformation).
[Second](http://dev.gentoo.org/~swift/blog/01/1_createhitlist.txt), I
create a "hitlist" which generates the CPEs. With the recent change to
`metadata.xml` this step can be simplified a lot.
[Third](http://dev.gentoo.org/~swift/blog/01/2_matchcve.txt), I try to
match the CPE data with the CVE data, depending on a given time delay of
commits. In other words, you can ask possible CVE fixes for commits made
in the last few XXX days.
