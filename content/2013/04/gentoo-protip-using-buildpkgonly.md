Title: Gentoo protip: using buildpkgonly
Date: 2013-04-25 03:50
Category: Gentoo
Tags: binpkg, emerge, Gentoo, protip
Slug: gentoo-protip-using-buildpkgonly

If you don't want to have the majority of builds run in the background
while you are busy on the system, but you don't want to automatically
install software in the background when you are not behind your desk,
then perhaps you can settle for using [binary
packages](https://wiki.gentoo.org/wiki/Binary_package_guide). I'm not
saying you need to setup a build server and such or do your updates
first in a chroot.

No, what this tip is for is to use the *--buildpkgonly* parameter of
**emerge** at night, building some of your software (often the larger
ones) as binary packages only (storing those in the `${PKGDIR}` which
defaults to `/usr/portage/packages`). When you are then on your system,
you can run the update with binary package included:

    # emerge -puDk world

To use *--buildpkgonly*, all package(s) that Portage wants to build must
have all their dependencies met. If not, then the build will not go
through and you're left with no binary packages at all. So what we do is
to create a script that looks at the set of packages that would be
build, and then one for one building the binary package.

When ran, the script will attempt to build binary packages for those
that have no dependency requirements anymore. Those builds will then
create a binary package but will not be merged on the system. When you
later update your system, including binary packages, those packages that
have been build during the night will be merged quickly, reducing the
build load on your system while you are working on it.

    #!/bin/sh

    LIST=$(mktemp);

    emerge -puDN --color=n --columns --quiet=y world | awk '{print $2}' > ${LIST};

    for PACKAGE in $(cat ${LIST});
    do
      printf "Building binary package for ${PACKAGE}... "
      emerge -uN --quiet-build --quiet=y --buildpkgonly ${PACKAGE};
      if [[ $? -eq 0 ]];
      then
        echo "ok";
      else
        echo "failed";
      fi
    done

I ran this a couple of days ago when *-uDN world* showed 46 package
updates (including a few hefty ones like chromium). After running this
script, 35 of them had a binary package ready so the *-uDN world* now
only needed to build 11 packages, merging the remainder from binary
packages.
