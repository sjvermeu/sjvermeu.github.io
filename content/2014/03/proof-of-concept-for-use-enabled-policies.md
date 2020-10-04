Title: Proof of concept for USE enabled policies
Date: 2014-03-31 18:33
Category: Gentoo
Tags: alsa, policy, selinux
Slug: proof-of-concept-for-use-enabled-policies

*tl;dr:* Some (`-9999`) policy ebuilds now have `USE` support for
building in (or leaving out) SELinux policy statements.

One of the "problems" I have been facing since I took on the maintenance
of SELinux policies within Gentoo Hardened is the (seeming) inability to
make a "least privilege" policy that suits the flexibility that Gentoo
offers. As a quick recap: SELinux policies describe the "acceptable
behavior" of an application (well, domain to be exact), often known as
the "normalized behavior" in the security world. When an application
(which runs within a SELinux domain) wants to perform some action which
is not part of the policy, then this action is denied.

Some applications can have very broad acceptable behavior. A web server
for instance might need to connect to a database, but that is not the
case if the web server only serves static information, or dynamic
information that doesn't need a database. To support this, SELinux has
*booleans* through which optional policy statements can be enabled or
disabled. So far so good.

Let's look at a second example: ALSA. When ALSA enabled applications
want to access the sound devices, they use IPC resources to
"collaborate" around the sound subsystem (semaphores and shared memory
to be exact). Semaphores inherit the type of the domain that first
created the semaphore (so if **mplayer** creates it, then the semaphore
has the `mplayer_t` context) whereas shared memory usually gets the
tmpfs-related type (`mplayer_tmpfs_t`). When a second application wants
to access the sound device as well, it needs access to the semaphore and
shared memory. Assuming this second application is the browser, then
`mozilla_t` needs access to semaphores by `mplayer_t`. And the same for
`chromium_t`. Or `java_t` applications that are ALSA-enabled. And
`alsa_t`. And all other applications that are ALSA enabled.

In Gentoo, ALSA support can be made optional through `USE="alsa"`. If a
user decides not to use ALSA, then it doesn't make sense to allow all
those domains access to each others' semaphores and shared memory. And
although SELinux booleans can help, this would mean that for each
application domain, something like the following policy would need to
be, optionally, allowed:

    # For the mplayer_t domain:
    optional_policy(`
      tunable_policy(`use_alsa',`
        mozilla_rw_semaphores(mplayer_t)
        mozilla_rw_shm(mplayer_t)
        mozilla_tmpfs_rw_files(mplayer_t)
      ')
    ')

    optional_policy(`
      tunable_policy(`use_alsa',`
        chromium_rw_semaphores(mplayer_t)
        chromium_rw_shm(mplayer_t)
        chromium_tmpfs_rw_files(mplayer_t)
      ')
    ')

And this for all domains that are ALSA-enabled. Every time a new
application is added that knows ALSA, the same code needs to be added to
all policies. And this only uses a single SELinux boolean (whereas
Gentoo supports `USE="alsa"` on per-package level), although we can
create separate booleans for each domain if we want to. Not that that
will make it more manageable.

One way of dealing with this would be to use attributes. Say we have a
policy like so:

    attribute alsadomain;
    attribute alsatmpfsfile;

    allow alsadomain alsadomain:sem rw_sem_perms;
    allow alsadomain alsadomain:shm rw_shm_perms;
    allow alsadomain alsatmpfsfile:file rw_file_perms;

By assigning the attribute to the proper domains whenever ALSA support
is needed, we can toggle this more easily:

    # In alsa.if
    interface(`alsa_domain',`
      gen_require(`
        attribute alsadomain;
        attribute alsatmpfsfile;
      ')
      typeattribute $1 alsadomain;
      typeattribute $2 alsatmpfsfile;
    ')


    # In mplayer.te
    optional_policy(`
      tunable_policy(`use_alsa',`
        alsa_domain(mplayer_t, mplayer_tmpfs_t)
      ')
    ')

That would solve the problem of needlessly adding more calls in a policy
for every ALSA application. And hey, we can probably live with either a
global boolean (`use_alsa`) or per-domain one (`mplayer_use_alsa`) and
toggle this according to our needs.

Sadly, the above is not possible: one cannot define `typeattribute`
assignments inside a `tunable_policy` code: attributes are part of the
non-conditional part of a SELinux policy. The solution would be to
create build-time conditionals (rather than run-time):

    ifdef(`use_alsa',`
      optional_policy(`
        alsa_domain(mplayer_t, mplayer_tmpfs_t)
      ')
    ')

This does mean that `use_alsa` has to be known when the policy is built.
For Gentoo, that's not that bad, as policies are part of separate
packages, like `sec-policy/selinux-mplayer`. So what I now added was
USE-enabled build-time decisions that trigger this code. The
`selinux-mplayer` package has `IUSE="alsa"` which will enable, if set,
the `use_alsa` build-time conditional.

As a result, we now support a better, fine-grained privilege setting
inside the SELinux policy which is triggered through the proper USE
flags.

Is this a perfect solution? No, but it is manageable and known to Gentoo
users. It isn't perfect, because it listens to the USE flag setting for
the `selinux-mplayer` package (and of course globally set USE flags) but
doesn't "detect" that the firefox application (for which the policy is
meant) is or isn't built with `USE="alsa"`. So users/administrators will
need to keep this in mind when using package-local USE flag definitions.

Also, this will make it a bit more troublesome for myself to manage the
SELinux policy for Gentoo (as upstream will not use this setup, and as
such patches from upstream might need a few manual corrections before
they apply to our tree). However, I gladly take that up if it means my
system will have somewhat better confinement.
