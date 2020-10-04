Title: cvechecker updates
Date: 2011-03-27 22:20
Category: Security
Slug: cvechecker-updates

The in-svn version of cvechecker has seen quite a few changes in the
last few days. I'm adding support for MySQL to it. This support will be
added in three steps:

1.  support the same features as cvechecker currently does using sqlite
2.  streamline the database code so that duplicate code in the sqlite
    implementation and mysql implementation is removed
3.  support multi-node systems with a single master database

The latter is something I've been meaning to implement for quite some
time: have a single system dedicated to download and store the latest
CVE entries in the database (as well as CPE definitions) whereas several
systems can use the database by storing their own system information and
getting a mapping from that information against the CVE database. Even
more so, it would allow you to query the database asking on which
systems a particular software was detected, or which systems still have
vulnerable software installed.

When the MySQL support is implemented, I'm going to work a bit on the
`versions.dat` file, because it doesn't really support many services
currently. I'm going to use it against my "virtual network" (a
combination of KVM guests running bind (master/slave), ldap
(multi-master), postfix, apache, squirrelmail, courier, postgresql,
mysql and more) and enhance it so that it detects all those components
as well.

Oh, btw, I had a request to include support for just telling cvechecker
which components/software to look for (rather than it scanning the files
and deducing it from regular expressions and the like). The in-svn
version supports it, so it will definitely be part of the 3.0 release.
