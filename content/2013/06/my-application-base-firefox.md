Title: My application base: firefox
Date: 2013-06-07 03:50
Category: Free-Software
Tags: browser, firefox, mab
Slug: my-application-base-firefox

Browsers are becoming application disclosure frameworks rather than the
visualization tools they were in the past. More and more services, like
the
[Draw.io](http://blog.siphos.be/2013/06/my-application-base-draw-io/)
one I discussed not that long ago, are using browsers are their client
side while retaining the full capabilities of end clients (such as drag
and drop, file management, editing capabilities and more).

The browser I use consistently is
[Firefox](https://www.mozilla.org/en-US/firefox/fx/). I do think I will
move to Chromium (or at least use it more actively) sooner or later, but
firefox at this point in time covers all my needs. It isn't just the
browser itself though, but also the wide support in add-ons that I am
relying upon. This did make me push out SELinux policies to restrict the
actions that firefox can do, because it has become almost an entire
operating system by itself (like ChromeOS versus Chrome/Chromium). With
a few tunable settings (SELinux booleans) I can enable/disable access to
system devices (such as webcams), often vulnerable plugins (flash,
java), access to sensitive user information (I don't allow firefox
access to regular user files, only to the downloaded content) and more.

One of the add-ons that is keeping me with Firefox for now is
[NoScript](http://noscript.net/). Being a security-conscious guy, being
able to limit the exposure of my surfing habits to advertisement
companies (and others) is very important to me. The NoScript add-on does
this perfectly. The add-on is very extensible (although I don't use that
- just the temporary/permanent allow) and easy to work with: on a site
where you notice some functionality isn't working, right-click and seek
the proper domain to allow methods from. Try-out a few of them
temporarily until you find the "sweet spot" and then allow those for
future reference.

Another extension I use often (not often enough) is the spelling checker
capabilities. On multi-line fields, this gives me enough feedback about
what I am typing and if it doesn't use a mixture of American English and
British English. But with a simple javascript bookmarklet, I can even
enable spell check on a rendered page (simple javascript that sets the
designMode variable and the contentEditable variable to true), which is
perfect for the Gorg integration while developing Gentoo documentation.

The abilities of a browser are endless: I have extensions that offer
ePub reading capabilities, full web development capabilities (to
edit/verify CSS and HTML changes), HTTPS Everywhere (to enforce SSL when
the site supports it), SQLite manager, Tamper Data (to track and
manipulate HTTP headers) and more. With the GoogleTalk plugins, doing
video chats and such is all done through the browser.

This entire eco-system of plugins and extensions make the browser a big
but powerful interface, but also an important resource to properly
manage: keep it up-to-date, backup your settings (including auto-stored
passwords if you enable that), verify its integrity and ensure it runs
in its confined SELinux domain.
