Title: Public support channels: irc
Date: 2013-05-16 03:50
Category: Free-Software
Tags: chat, irc, support
Slug: public-support-channels-irc

I've [said
it](http://blog.siphos.be/2012/12/why-would-paid-for-support-be-better/)
before - support channels for free software are often (imo) superior to
the commercial support that you might get with vendors. And although
those vendors often try to use "modern" techniques, I fail to see why
the old, but proven/stable methods would be wrong.

Consider the "Chat with Support" feature that many vendors have on their
site. Often, these services use a webbrowser, AJAX-driven method for
talking with support engineers. The problem with this that I see is that
it is difficult to keep track of the feedback you got over time (unless
you manually copy/paste the information), and again that it isn't
public. With free software communities, we still often redirect such
"online" support requests to IRC.

*Internet Relay Chat* has been around for ages
([1988](https://en.wikipedia.org/wiki/IRC) according to wikipedia) and
still quite active. Gentoo has all of its support channels on the
[freenode](http://www.freenode.net) IRC network: a community-driven,
active `#gentoo` channel with often crosses the 1000 users, a
`#gentoo-dev` development-related channel where many developers
communicate, the `#gentoo-hardened` channel for all questions and
support regarding Gentoo Hardened specifics, etc.

Using IRC has many advantages. One is that logs can be kept (either
individually or by the project itself) that can be queried later by the
people who want to provide support (to see if questions have already
been popping up, see what the common questions are for the last few
days, etc.) or get support (to see if their question was already
answered in the past). Of course, these logs can be made public through
web interfaces quite easily. For users, such log functionality is
offered through the IRC client. Another very simple, yet interesting
feature is *highlighting*: give the set of terms for which you want to
be notified (usually through a highlight and a specific notification in
the client), making it easier to be on multiple channels without having
to constantly follow-up on all discussions.

Another advantage is that there is such a thing like "bots". Most Gentoo
related channels do not allow active bots on the channels except for the
project-approved ones (such as *willikens*). These bots can provide
project-specific help to users and developers alike:

-   Give one-line information about bugs reported on bugzilla (id,
    assignee, status, but also the URL where the user/developer can view
    the bug etc.)
-   Give meta information about a package (maintainer, herd, etc.), herd
    (members), GLSA details, dependency information, etc.
-   -   Allow users to query if a developer is
    [away](https://dev.gentoo.org/devaway/) or not
-   Create notes (messages) for users that are not online yet but for
    which you know they come online later (and know their nickname or
    registered username)
-   Notify when commits are made, or when tweets are sent that match a
    particular expression, etc.

Furthermore, the IRC protocol has many features that are very
interesting to use in free software communities as well. You can still
do private chats (when potentially confidential data is exchanged) for
instance, or even exchange files (although that is less common to use in
free software communities). There is also still some hierarchy in case
of abuse (channel operators can remove users from the chat or even ban
them for a while) and one can even quiet a channel when for instance
online team meetings are held (although using a different channel for
that might be an alternative).

IRC also has the advantage that connecting to the IRC channels has a
very low requirement (software-wise): one can use console-only chat
clients (in case users cannot get their graphical environment to work -
example is irssi) or even [webbrowser](http://webchat.freenode.net/)
based ones (if one wants to chat from other systems). Even smartphones
have good IRC applications, like [AndChat](http://www.andchat.net/) for
Android.

IRC is also distributed: an IRC network consists of many interconnected
servers who pass on all IRC traffic. If one node goes down, users can
access a different node and continue. That makes IRC quite
high-available. IRC network operators do need to try and keep the
network from splitting ("netsplit") which occurs when one part of the
distributed network gets segregated from the other part and thus two
"independent" IRC networks are formed. When that occurs, IRC operators
will try to join them back as fast as possible. I'm not going to explain
the details on this - it suffices to understand that IRC is a
distributed manner and thus often much more available than the "support
chat" sites that vendors provide.

So although IRC looks archaic, it is a very good match for support
channel requirements.
