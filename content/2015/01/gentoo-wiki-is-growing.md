Title: Gentoo Wiki is growing
Date: 2015-01-03 10:09
Category: Documentation
Tags: documentation, Gentoo, wiki
Slug: gentoo-wiki-is-growing

Perhaps it is because of the winter holidays, but the last weeks I've
noticed a lot of updates and edits on the Gentoo wiki.

The move to the
[Tyrian](https://wiki.gentoo.org/wiki/Project:Website/Tyrian) layout,
whose purpose is to eventually become the unified layout for all Gentoo
resources, happened first. Then, three common templates (`Code`, `File`
and `Kernel`) where deprecated in favor of their "\*Box" counterparts
(`CodeBox`, `FileBox` and `KernelBox`). These provide better parameter
support (which should make future updates on the templates easier to
implement) as well as syntax highlighting.

But the wiki also saw a number of contributions being added. I added a
short article on [Efibootmgr](https://wiki.gentoo.org/wiki/Efibootmgr)
as the [Gentoo
handbook](https://wiki.gentoo.org/wiki/Handbook:Main_Page) now also uses
it for its EFI related instructions, but other users added quite a few
additional articles as well. As they come along, articles are being
marked by editors for translation. For me, that's a trigger.

Whenever a wiki article is marked for translations, it shows up on the
[PageTranslation](https://wiki.gentoo.org/wiki/Special:PageTranslation)
list. When I have time, I pick one of these articles and try to update
it to move to a common style (the
[Guidelines](https://wiki.gentoo.org/wiki/Gentoo_Wiki:Guidelines) page
is the "official" one, and I have a
[Styleguide](https://wiki.gentoo.org/wiki/User:SwifT/Styleguide) in
which I elaborate a bit more on the use). Having a common style gives a
better look and feel to the articles (as they are then more alike),
gives a common documentation development approach (so everyone can join
in and update documentation in a similar layout/structure) and - most
importantly - reduces the number of edits that do little more than
switch from one formatting to another.

When an article has been edited, I mark it for translation, and then the
real workhorse on the wiki starts. We have several active translators on
the Gentoo wiki, who we cannot thank hard enough for their work (I used
to start at Gentoo as a translator, I have some feeling about their
work). They make the Gentoo documentation reachable for a broader
audience. Thanks to the use of the translation extension (kindly offered
by the Gentoo wiki admins, who have been working quite hard the last few
weeks on improving the wiki infrastructure) translations are easier to
handle and follow through.

The advantage of a translation-marked article is that any change on the
article also shows up on the list again, allowing me to look at the
change and perform edits when necessary. For the end user, this is
behind the scenes - an update on an article shows up immediately, which
is fine. But for me (and perhaps other editors as well) this gives a
nice overview of changes to articles (watchlists can only go so far) and
also shows the changes in a simple yet efficient manner. Thanks to this
approach, we can more actively follow up on edits and improve where
necessary.

Now, editing is not always just a few minutes of work. Consider the
[GRUB2](https://wiki.gentoo.org/wiki/GRUB2) article on the wiki. It was
marked for translation, but had some issues with its style. It was very
verbose (which is not a bad thing, but suggests to split information
towards multiple articles) and quite a few open discussions on its
[Discussions](https://wiki.gentoo.org/wiki/Talk:GRUB2) page. I started
editing the article around 13.12h local time, and ended at 19.40h.
Unlike with offline documentation, the entire process of the editing can
be followed through the page'
[history](https://wiki.gentoo.org/index.php?title=GRUB2&offset=&limit=100&action=history)).
And although I'm still not 100% satisfied with the result, it is imo
easier to follow through and read.

However, don't get me wrong - I do not feel that the article was wrong
in any way. Although I would appreciate articles that immediately follow
a style, I rather see more contributions (which we can then edit towards
the new style) than that we would start penalizing contributors that
don't use the style. That would work contra-productive, because it is
far easier to update the style of an article than to write articles. We
should try and get more contributors to document aspects of their Gentoo
journey.

So, please keep them coming. If you find a lack of (good) information
for something, start jotting down what you know in an article. We'll
gladly help you out with editing and improving the article then, but the
content is something you are probably best to write down.
