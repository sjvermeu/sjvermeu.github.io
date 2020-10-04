Title: Handbooks moved
Date: 2014-12-14 14:42
Category: Documentation
Tags: Gentoo, handbook, wiki
Slug: handbooks-moved

Yesterday the move of the [Gentoo
Wiki](https://wiki.gentoo.org/wiki/Handbook:Main_Page) for the Gentoo
handbooks (whose most important part are the installation instructions
for the various supported architectures) has been concluded, with a
last-minute addition being the [one-page
views](https://wiki.gentoo.org/wiki/Handbook:Main_Page#Viewing_the_handbook)
so that users who want to can view the installation instructions
completely within one view.

Because we use lots of
[transclusions](http://www.mediawiki.org/wiki/Transclusion) (i.e.
including different wiki articles inside another article) to support a
common documentation base for the various architectures, I did hit a
limit that prevented me from creating a single-page for the entire
handbook (i.e. "Installing Gentoo Linux", "Working with Gentoo",
"Working with portage" and "Network configuration" together), but I
could settle with one page per part. I think that matches most of the
use cases.

With the move now done, it is time to start tackling the various bugs
that were reported against the handbook, as well as initiate
improvements where needed.

I did make a (probably more - but this one is fresh in my memory)
mistake in the move though. I had to do a lot of the following:

``` {lang="xml"}

...
```

Without this, transcluded parts would suddenly show the translation tags
as regular text. Only afterwards (I'm talking about more than [400
different
pages](https://wiki.gentoo.org/wiki/Project:Documentation/HandbookDevelopment))
did I read that I should transclude the `/en` pages (like
`Handbook:Parts/Installation/About/en` instead of
`Handbook:Parts/Installation/About`) as those do not have the
translation specifics in them. Sigh.
