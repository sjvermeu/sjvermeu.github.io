Title: cvechecker 3.7 released
Date: 2017-03-02 10:00
Category: Free-Software
Tags: cvechecker
Slug: cvechecker-3.7-released

After a long time of getting too little attention from me, I decided to make a 
new [cvechecker](https://github.com/sjvermeu/cvechecker/wiki) release. There are
few changes in it, but I am planning on making a new release soon with lots of
clean-ups.

<!-- PELICAN_END_SUMMARY -->

**What has been changed**

So, what has changed? With this release (now at version 3.7) two bugs have been
fixed, one having a wrong URL in the CVE download and the other about the CVE
sequence numbers.

The first bug was an annoying one, which I should have fixed a long time ago.
Well, it was fixed in the repository, but I didn't make a new release for it. 
When downloading the `nvdcve-2.0-Modified.xml` file, the `pullcves` command used
the lowercase filename, which doesn't exist.

The second bug is about parsing the CVE sequence. On [January 2014](https://cve.mitre.org/cve/identifiers/syntaxchange.html)
the syntax changed to allow for sequence identifiers longer than 4 digits. The
cvechecker tool however did a hard validation on the length of the identifier,
and cut off longer fields.

That means that some CVE reports failed to parse in cvechecker, and thus cvechecker
didn't "know" about these vulnerabilities. This has been fixed in this release,
although I am not fully satisfied...

**What still needs to be done**

The codebase for cvechecker is from 2010, and is actually based on a prototype
that I wrote which I decided not to rewrite into proper code. As a result, the
code is not up to par.

I'm going to gradually improve and clean up the code in the next few [insert
timeperiod here]. I don't know if there will be feature improvements in the
next few releases (not that there aren't many feature enhancements needed) but
I hope that, once the code is improved, new functionality can be added more
easily.

But that's for another time. Right now, enjoy the new release.


