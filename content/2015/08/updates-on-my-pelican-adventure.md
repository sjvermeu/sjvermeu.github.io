Title: Updates on my Pelican adventure
Date: 2015-08-16 19:50
Category: Free-Software
Tags: blog, pelican, wordpress
Slug: updates-on-my-pelican-adventure

It's been a few weeks that I [switched](http://blog.siphos.be/2015/08/switching-to-pelican/)
my blog to [Pelican](http://blog.getpelican.com/), a static site generator build
with Python. A number of adjustments have been made since, which I'll happily
talk about.

<!-- PELICAN_END_SUMMARY -->

**The full article view on index page**

One of the features I wanted was to have my latest blog post to be fully
readable from the front page (called the _index_ page within Pelican). Sadly,
I could not find a plugin of setting that would do this, but I did find
a plugin that I can use to work around this: the [summary](https://github.com/getpelican/pelican-plugins/tree/master/summary)
plugin.

Enabling the plugin was a breeze. Extract the plugin sources in the `plugin/`
folder, and enable it in `pelicanconf.py`:

```python
PLUGINS = [..., 'summary']
```

With this plug-in, articles can use inline comments to tell the system at which
point the summary of the article stops. Usually, the summary (which is displayed
on index pages) is a first paragraph (or set of paragraphs). What I do is I now
manually set the summmary to the entire blog post for the latest post, and adjust
later when a new post comes up.

It might be some manual labour, but it fits nicely and doesn't hack around in the
code too much.

**Commenting with Disqus**

I had some remarks that the [Disqus](https://disqus.com/home/welcome/) integration
is not as intuitive as expected. Some readers had difficulties finding out how
to comment as a guest (without the need to log on through popular social media
or through Disqus itself).

Agreed, it is not easy to see at first sight that people need to start typing
their name in the _Or sign up with disqus_ before they can select _I'd rather post
as guest_. As I don't have any way of controlling the format and rendered code
with Disqus, I updated the theme a bit to add in two paragraphs on commenting.
The first paragraph tells how to comment as guest.

The second paragraph for now informs readers that non-verified comments are put
in the moderation queue. Once I get a feeling of how the spam and bots act on the
commenting system, I will adjust the filters and also allow guest comments to be
readily accessible (no moderation queue). Give it a few more weeks to get myself
settled and I'll adjust it.

If the performance of the site is slowed down due to the Disqus javascripts: both
Firefox (excuse me, Aurora) and Chromium have this at the initial load. Later, the
scripts are properly cached and load in relatively fast (a quick test shows
all pages I tried load in less than 2 seconds - WordPress was at 4). And if you're
not interested in commenting, then you can even use [NoScript](https://noscript.net/)
or similar plugins to disallow any remote javascript.

Still, I will continue to look at how to make commenting easier. I recently allowed
unmoderated comments (unless a number of keywords are added, and comments with links
are also put in the moderation queue). If someone knows of another comment-like
system that I could integrate I'm happy to hear about it as well.

**Search**

My issue with Tipue Search has been fixed by reverting a change in `tipue_search.py`
(the plugin) where the URL was assigned to the `loc` key instead of `url`. It is
probably a mismatch between the plugin and the theme (the change of the key was done
in May in Tipue Search itself).

With this minor issue changed, the search capabilities are back on track on my blog.
Enabling is was a matter of:

```python
PLUGINS = [..., `tipue_search`]
DIRECT_TEMPLATES = ((..., 'search'))
```

**Tags and categories**

WordPress supports multiple categories, but Pelican does not. So I went through
the various posts that had multiple categories and decided on a single one. While
doing so, I also reduced the [categories](http://blog.siphos.be/categories.html) to
a small set:

- Databases
- Documentation
- Free Software
- Gentoo
- Misc
- Security
- SELinux

I will try to properly tag all posts so that, if someone is interested in a very
particular topic, such as [PostgreSQL](http://blog.siphos.be/tag/postgresql/index.html), he can reach
those posts through the tag.

