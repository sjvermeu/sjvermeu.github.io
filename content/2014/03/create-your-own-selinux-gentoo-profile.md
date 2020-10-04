Title: Create your own SELinux Gentoo profile
Date: 2014-03-24 21:51
Category: Gentoo
Tags: Gentoo, profile
Slug: create-your-own-selinux-gentoo-profile

Or any other profile for that matter ;-)

A month or so ago we got the question how to enable SELinux on a Gentoo
profile that doesn't have a `<some profilename>/selinux` equivalent.
Because we don't create SELinux profiles for all possible profiles out
there, having a way to do this yourself is good to know.

Sadly, the most efficient way to deal with this isn't supported by
Portage: creating a `parent` file pointing to
`/usr/portage/profiles/features/selinux` in `/etc/portage/profile`, as
is done for all SELinux enabled profiles. The `/etc/portage/profile`
location (where users can do local changes to the profile settings) does
not support a `parent` file in there.

Luckily, enabling SELinux is a matter of merging the files in
`/usr/portage/profiles/features/selinux` into `/etc/portage/profile`. If
you don't have any files in there, you can blindly copy over the files
from `features/selinux`.

*Edit:* *aballier* on `#gentoo-dev` mentioned that you can create a
`/etc/portage/make.profile` directory (instead of having it be a symlink
managed by **eselect profile**) which does support `parent` files. In
that case, just create one with two entries: one path to the profile you
want, and one path to the `features/selinux` location.
