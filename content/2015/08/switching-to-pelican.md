Title: Switching to Pelican
Date: 2015-08-02 04:09
Category: Free-Software
Tags: blog, pelican, wordpress
Slug: switching-to-pelican

Nothing beats a few hours of flying to get things moving on stuff. Being
offline for a few hours with a good workstation helps to not be disturbed
by external actions (air pockets notwithstanding).

Early this year, I expressed my [intentions to move to Pelican](http://blog.siphos.be/2015/03/trying-out-pelican-part-one/)
from WordPress. I wasn't actually unhappy with WordPress, but the security
concerns I had were a bit too much for blog as simple as mine. Running a
PHP-enabled site with a database for something that I can easily handle through
a static site, well, I had to try.

<!-- PELICAN_END_SUMMARY -->

Today I finally moved the blog, imported all past articles as well as
comments. For the commenting, I now use [disqus](http://blog.siphos.be/2015/03/trying-out-pelican-part-one/)
which integrates nicely with Pelican and has a fluid feel to it. I wanted to
use the [Tipue Search](http://www.tipue.com/search/) plug-in as well for
searching through the blog, but I had to put that on hold as I couldn't get
the results of a search to display nicely (all I got were links to
"undefined"). But I'll work on this.

**Configuring Pelican**

Pelican configuration is done through `pelicanconf.py` and `publishconf.py`. 
The former contains all definitions and settings for the site which are also
useful when previewing changes. The latter contains additional (or overruled)
settings related to publication.

In order to keep the same links as before (to keep web crawlers happy, as well
as links to the blog from other sites and even the comments themselves) I did
had to update some variables, but the Internet was strong on this one and I had
little problems finding the right settings:

```python
# Link structure of the site
ARTICLE_URL = u'{date:%Y}/{date:%m}/{slug}/'
ARTICLE_SAVE_AS = u'{date:%Y}/{date:%m}/{slug}/index.html'
CATEGORY_URL = u'category/{slug}'
CATEGORY_SAVE_AS = u'category/{slug}/index.html'
TAG_URL = u'tag/{slug}/'
TAG_SAVE_AS = u'tag/{slug}/index.html'
```

The next challenges were (and still are, I will have to check if this is working
or not soon by checking the blog aggregation sites I am usually aggregated on)
the RSS and Atom feeds. From the access logs of my previous blog, I believe that
most of the aggregation sites are using the `/feed/`, `/feed/atom` and 
`/category/*/feed` links.

Now, I would like to move the aggregations to XML files, so that the RSS feed is
available at `/feed/rss.xml` and the Atom feed at `/feed/atom.xml`, but then the
existing aggregations would most likely fail because they currently don't use
these URLs. To fix this, I am now trying to generate the XML files as I would
like them to be, and create symbolic links afterwards from `index.html` to the
right XML file.

The RSS/ATOM settings I am currently using are as follows:

```python
CATEGORY_FEED_ATOM = 'category/%s/feed/atom.xml'
CATEGORY_FEED_RSS = 'category/%s/feed/rss.xml'
FEED_ATOM = 'feed/atom.xml'
FEED_ALL_ATOM = 'feed/all.atom.xml'
FEED_RSS = 'feed/rss.xml'
FEED_ALL_RSS = 'feed/all.rss.xml'
TAG_FEED_ATOM = 'tag/%s/feed/atom.xml'
TAG_FEED_RSS = 'tag/%s/feed/rss.xml'
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None
```

Hopefully, the existing aggregations still work, and I can then start asking
the planets to move to the XML URL itself. Some tracking on the access logs
should allow me to see how well this is going.

**Next steps**

The first thing to make sure is happening correctly is the blog aggregation and
the comment system. Then, a few tweaks are still on the pipeline.

One is to optimize the front page a bit. Right now, all articles are
summarized, and I would like to have the last (or last few) article(s) fully
expanded whereas the rest is summarized. If that isn't possible, I'll probably
switch to fully expanded articles (which is a matter of setting a single
variable).

Next, I really want the search functionality to work again. Enabling the Tipue
search worked almost flawlessly - search worked as it should, and the resulting
search entries are all correct. The problem is that the URLs that the entries
point to (which is what users will click on) all point to an invalid
("undefined") URL.

Finally, I want the printer-friendly one to be without the social / links on
the top right. This is theme-oriented, and I'm happily using
[pelican-bootstrap3](https://github.com/DandyDev/pelican-bootstrap3) right now,
so I don't expect this to be much of a hassle. But considering that my blog is
mainly technology oriented for now (although I am planning on expanding that)
being able to have the articles saved in PDF or printed in a nice format is
an important use case for me.


