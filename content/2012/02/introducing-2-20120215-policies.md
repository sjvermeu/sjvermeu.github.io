Title: Introducing 2.20120215 policies
Date: 2012-02-26 18:40
Category: Gentoo
Slug: introducing-2-20120215-policies

A few weeks after being
[released](http://oss.tresys.com/pipermail/refpolicy/2012-February/004953.html),
we now have the 20120215-based policies available for our users (and
also the newer userspace utilities). The packages currently reside in
the hardened-dev overlay as they will need to see sufficient testing
before we merge those to the main tree. For most users, nothing changes,
albeit there are a few changes under the hood that you might get in
contact with later...

The *selinux-base-policy* package now depends on a new package called
*selinux-base*. This is the "real" base policy package, and now only
includes those modules that upstream (reference policy) marks as being
base modules. The rest of the modules that we (Gentoo) originally
included in base are now built by the *selinux-base-policy* package and
inserted in the policy store together with the base policy. This change
is done to make future development a bit more flexible, but also because
the policy build fails when we include too many packages.

The *selinux-unconfined* package loads in the unconfined module. Users
that know the difference between the *strict* and *targeted* policy
types: loading the unconfined module in a "strict" policy will make the
system support domains like in "targeted" mode. Currently, there is
little use in this module as we (err, I) still need to get this in a
good shape. This change is needed to support unconfined domains later
when we work with MCS or MLS. The older definitions (using targeted or
strict) remain supported though.

The pesky change we had to do to
`/lib64/rcscripts/addons/lvm-st{art,op}.sh` is not necessary anymore.
This has nothing to do with the tools, but more with an update on the
policy itself. I have to give you some reason to upgrade, don't I ;-)

Now that the new policy is in, we can start using named transitions as
well as use translations so that our file contexts aren't cluttered with
all those /lib64 + /lib definitions. These changes will go in later.

For those interested in helping, please give these policies thorough
testing. I had some work in "forward-porting" the patches we had that
weren't included upstream yet because of changes in the underlying
structure. I hope none are forgotten. If you do find regressions, either
ping me on IRC or file a bugreport.
