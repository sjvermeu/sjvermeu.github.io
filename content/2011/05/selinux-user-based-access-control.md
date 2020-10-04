Title: SELinux User-Based Access Control
Date: 2011-05-02 22:14
Category: SELinux
Slug: selinux-user-based-access-control

Within the reference policy, support is given to a feature called *UBAC
constraints*. Here, UBAC stands for *User Based Access Control*. The
idea behind the constraint is that any activity between two types (say
`foo_t` and `bar_t`) can be prohibited if the user contexts of the
resources that are using those types are different. So even though
`foo_t` can read files with label `bar_t`, a process running as
`user1:user_r:foo_t` will not be able to read a file labeled
`user2:user_r:bar_t`. The policy defines the constraint like so (taken
from `policy/constraints` and rewritten in a more readable code):

    Action is okay if
      user1 == user2, or
      user1 == system_u, or
      user2 == system_u, or
      type1 is not a UBAC constrained type, or
      type2 is not a UBAC constrained type

So the constraint only denies an activity if the users involved are not
`system_u` (that would render your system useless), not the same, and
*both types are ubac constrained types*. The latter is, within the
policy, set using type attributes:

    ~$ seinfo -aubac_constrained_type -x
    ubac_constrained_type
       screen_var_run_t
       admin_crontab_t
       links_input_xevent_t
       ...

Some domains are also UBAC exempt (currently I know of the `sysadm_t`
domain - cfr the `ubacproc` and `ubacfile` attributes), meaning that
activities started from the `sysadm_t` domain will not trigger the
constraint.

UBAC gives some additional control on information flow between
resources. But it isn't perfect. One major downside is that the error
you get when the constraint is hit is a simple AVC denial where most
users would just check the inter-type privileges, without paying
attention to the difference in SELinux user identities. Another is that
it might be difficult for users or administrators that use different
SELinux user identities to still work properly with UBAC constrained
domains. Work is on the way in the SELinux development to improve the
role-based access control (RBAC) by allowing files and directories to
have a role as well (rather than the `object_r` placeholder used
currently) and then work on those roles. You can then grant the users
that need access to a particular resource the necessary role rather than
requiring those users to use the same SELinux user id. This would take
at least one major downside of UBAC away and I'm hoping that the logging
will improve on this as well.

Of course, I do not ramble about UBAC here because it is fun (well yes,
yes it is fun) but because in Gentoo, we've hit one UBAC-related issue.
When a user starts vixie-cron, the root crontab would fail to be loaded.
What gives? The root crontab has the SELinux identity of `staff_u` (as
it is created by a regular staff user that su(do)'ed) whereas the
`cronjob_t` process would have the SELinux identity of `root`. Bang.
Dead. No error beyond what vixie-cron gives.

Of course this can be easily worked around. **chcon -u root
/var/spool/cron/crontabs/root** works, or you can recreate the crontab
as a console-logged-on root user. We could also change the default
context used by `cronjob_t` to use `staff_u:sysadm_r:cronjob_t` for
root. But we can also take a look at how other distributions do this.
What gives: most distributions *disable* UBAC within the policy. Their
reasons might vary, but manageability of the policy comes to mind, as
well as reducing the number of (difficult to debug) problems. Most are
keen to include the RBAC at some point in the future though. Some
discussion on \#gentoo-hardened and \#selinux later, and I decided to
use a USE flag called "ubac" to optionally enable UBAC within the
policy. How very Gentoo, isn't it? At least users have the choice of
using UBAC or not (I know I'm going to enable it) and when RBAC is
available, we'll definitely make sure that support for RBAC is available
too.

Currently in the hardened overlay,
`sec-policy/selinux-base-policy-2.20101213-r13`. Take your pick on it,
give it a try and report any bugs you have on
[Bugzilla](https://bugs.gentoo.org). And if you enable USE="ubac", you
get user based access control for free.

PS I'm also going to reapply for Gentoo developer-ship and, amongst
other things, help out the hardened team with SELinux policies and
documentation.
