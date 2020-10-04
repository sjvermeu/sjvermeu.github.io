Title: cvechecker 3.0
Date: 2011-04-12 22:47
Category: Security
Slug: cvechecker-3-0

I'm pleased to announce the immediate availability of [cvechecker
3.0](http://cvechecker.sourceforge.net). It contains two major feature
enhancements: watchlists and MySQL support.

*watchlists* allow cvechecker to track and report on CVEs for software
that cvechecker didn't detect on the system (or perhaps even isn't
installed on the system). You can use watchlists to stay informed of
potential vulnerabilities in software used at work on servers where you
are not allowed (or do not want) to run cvechecker on. To use
watchlists, create a text file containing the CPE identifiers for the
software that you want to watch out for, and add it to the database:

    ~$ cat watchlist.txt
    cpe:/a:microsoft:excel:2003:::

    ~$ cvechecker -d -w watchlist.txt
    Adding CPE entries
      - Added watch for cpe:/a:microsoft:excel:2003:::

The second major feature is support for MySQL. This is the first
server-oriented RDBMS that cvechecker supports (earlier versions worked
with sqlite only) although sqlite support remains available as well. I
hope to extend the number of supported databases in the future (say
PostgreSQL, Oracle, SQL Server, ...). With support for server RDBMSes
came of course the requirement that multiple cvechecker clients are able
to use the same server (as the CVE and CPE data itself can be shared).
With the 3.0 release, this is supported as each client now "adds" to the
data both his hostname as well as an (optional) user defined value
(which can be anything you like). If unset, this user value is set to
the hostname, but you can use things like the systems' serial ID or
asset ID.

I'm hoping all users have fun with it - I know I have while writing it.
Feedback, remarks, feature requests, bugs and other criticism is always
very much appreciated.
