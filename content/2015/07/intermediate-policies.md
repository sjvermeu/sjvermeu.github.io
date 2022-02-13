Title: Intermediate policies
Date: 2015-07-05 18:17
Category: SELinux
Tags: community, contributions, policy-development, selinux
Slug: intermediate-policies

When developing SELinux policies for new software (or existing ones
whose policies I don't agree with) it is often more difficult to finish
the policies so that they are broadly usable. When dealing with personal
policies, having them "just work" is often sufficient. To make the
policies reusable for distributions (or for the upstream project), a
number of things are necessary:

-   Try structuring the policy using the style as suggested by refpolicy
    or Gentoo
-   Add the role interfaces that are most likely to be used or required,
    or which are in the current draft implemented differently
-   Refactor some of the policies to use refpolicy/Gentoo style
    interfaces
-   Remove the comments from the policies (as refpolicy does not want
    too verbose policies)
-   Change or update the file context definitions for default
    installations (rather than the custom installations I use)

<!-- PELICAN_END_SUMMARY -->

This often takes quite some effort. Some of these changes (such as the
style updates and commenting) are even counterproductive for me
personally (in the sense that I don't gain any value from doing so and
would have to start maintaining two different policy files for the same
policy), and necessary only for upstreaming policies. As a result, I
often finish with policies that I just leave for me personally or
somewhere on a public repository (like these
[Neo4J](https://github.com/sjvermeu/small.coding/tree/master/selinux-modules/neo4j)
and
[Ceph](https://github.com/sjvermeu/small.coding/tree/master/selinux-modules/ceph)
policies), without any activities already scheduled to attempt to
upstream those.

But not contributing the policies to a broader public means that the
effort is not known, and other contributors might be struggling with
creating policies for their favorite (or necessary) technologies. So the
majority of policies that I write I still hope to eventually push them
out. But I noticed that these last few steps for upstreaming (the ones
mentioned above) might only take a few hours of work, but take me over 6
months (or more) to accomplish (as I often find other stuff more
interesting to do).

I don't know yet how to change the process to make it more interesting
to use. However, I do have a couple of wishes that might make it easier
for me, and perhaps others, to contribute:

-   Instead of reacting on contribution suggestions, work on a common
    repository together. Just like with a wiki, where we don't aim for a
    100% correct and well designed document from the start, we should
    use the strength of the community to continuously improve policies
    (and to allow multiple people to work on the same policy). Right
    now, policies are a one-man publication with a number of people
    commenting on the suggested changes and asking the one person to
    refactor or update the change himself.
-   Document the style guide properly, but don't disallow contributions
    if they do not adhere to the style guide completely. Instead, merge
    and update. On successful wikis there are even people that update
    styles without content updates, and their help is greatly
    appreciated by the community.
-   If a naming convention is to be followed (which is the case
    with policies) make it clear. Too often the name of an interface is
    something that takes a few days of discussion. That's not productive
    for policy development.
-   Find a way to truly create a "core" part of the policy and a
    modular/serviceable approach to handle additional policies. The idea
    of the `contrib/` repository was like that, but failed to live up to
    its expectations: the number of people who have commit access to the
    contrib is almost the same as to the core, a few exceptions
    notwithstanding, and whenever policies are added to contrib they
    often require changes on the core as well. Perhaps even support
    overlay-type approaches to policies so that intermediate policies
    can be "staged" and tested by a larger audience before they are
    vetted into the upstream reference policy.
-   Settle on how to deal with networking controls. My suggestion would
    be to immediately support the TCP/UDP ports as assigned by IANA (or
    another set of sources) so that additional policies do not need to
    wait for the base policy to support the ports. Or find and support a
    way for contributions to declare the port types themselves (we
    probably need to focus on CIL for this).
-   Document "best practices" on policy development where certain types
    of policies are documented in more detail. For instance, desktop
    application profiles, networked daemons, user roles, etc. These best
    practices should not be mandatory and should in fact support a broad
    set of privilege isolation. With the latter, I mean that there are
    policies who cover an entire category of systems (init systems, web
    servers), a single software package or even the sub-commands and
    sub-daemons of that package. It would surprise me if this can't be
    supported better out-of-the-box (as in, through a well
    thought-through base policy framework and styleguide).

I believe that this might create a more active community surrounding
policy development.
