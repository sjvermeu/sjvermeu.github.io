Title: Gentoo SELinux policy release script
Date: 2013-12-11 18:37
Category: Gentoo
Tags: Gentoo, hardened, policy, release, selinux
Slug: gentoo-selinux-policy-release-script

A few months ago, I wrote a small script that aids in the creation of
new SELinux policy packages. The script is on the
[repository](http://git.overlays.gentoo.org/gitweb/?p=proj/hardened-refpolicy.git;a=summary)
itself, in the `gentoo/` subdirectory, and is called
`release-prepare.sh`.

The reason for the script is that there are a number of steps to
perform, one of which (tagging the release) I forgot to do too often. So
today I made a new release of the policy packages (2.20130424-r4) with
the script, and decided to blog about it as other developers in the
hardened team might one day be asked to make a release when I'm not
available.

When the script is called, it spits out the usual help information.

    $ sh release-prepare.sh -h
    Usage: release-prepare.sh  

    Example: release-prepare.sh 2.20130424-r2 2.20130424-r3

    The script will copy the ebuilds of the  towards the
     and update the string occurrences of that version
    (mostly for the BASEPOL variable).

    The following environment variables must be declared correctly for the script
    to function properly:
      - GENTOOX86 should point to the gentoo-x86 checkout
        E.g. export GENTOOX86="/home/user/dev/gentoo-x86"
      - HARDENEDREFPOL should point to the hardened-refpolicy.git checkout
        E.g. export HARDENEDREFPOL="/home/user/dev/hardened-refpolicy"
      - REFPOLRELEASE should point to the current latest /release/ of the reference
        policy (so NOT to a checkout), extracted somewhere on the file system.
        E.g. export REFPOLRELEASE="/home/user/local/refpolicy-20130424"

So first, we need to export three environment variables needed by the
script:

-   `GENTOOX86` points to the CVS checkout of the Portage tree. It is
    used to create new ebuilds.
-   `HARDENEDREFPOL` is the git checkout of the policy repository. This
    one is used to read the changes from to generate a patch.
-   `REFPOLRELEASE` is an extracted `refpolicy-20130424.tar.gz` (the
    upstream release of the reference policy). This extracted location
    is needed to generate the patch (the difference between our
    repository and the upstream release).

After setting the variables, the script does its magic:

    $ sh release-prepare.sh 2.20130424-r3 2.20130424-r4
    Creating patch 0001-full-patch-against-stable-release.patch... done
    Creating patch bundle for 2.20130424-r4... done
    Copying patch bundle into /usr/portage/distfiles and dev.g.o... done
    Removing old patchbundle references in Manifest (in case of rebuild)... done
    Creating new ebuilds based on old version... done
    Marking ebuilds as ~arch... done
    Creating tag 2.20130424-r4 in our repository... done
    The release has now been prepared.

    Please go do the following to finish up:
    - In /home/swift/dev/gentoo-x86/sec-policy go "cvs add" all the new ebuilds
    - In /home/swift/dev/gentoo-x86/sec-policy run "repoman manifest" and "repoman full"

    Then, before finally committing - do a run yourself, ensuring that the right
    version is deployed of course:
    - "emerge -1 sec-policy/selinux-aide
    sec-policy/selinux-alsa
    ...
    Only then do a 'repoman commit -m 'Release of 2.20130424-r4''.

The script performs the following steps:

1.  It creates the patch with the difference between the main refpolicy
    release and our repository. Our repository closely follows the
    upstream release, but still contains quite a few changes that have
    not been upstreamed yet (due to history loss of the changes, or the
    changes are very gentoo-specific, or the changes still need to
    be improved). In the past, we maintained all the patches separately,
    but this meant that the deployment of the policy ebuilds took too
    long (around 100 patches being applied takes a while, and took more
    than 80% of the total deployment time on a regular server system).
    By using a single patch file, the deployment time is
    reduced drastically.
2.  It then compresses this patch file and stores it in
    `/usr/portage/distfiles` (so that later `repoman manifest` can take
    the file into account) as well as on my dev.gentoo.org location
    (where it is referenced). If other developers create a release, they
    will need to change this location (and the pointer in the ebuilds).
3.  Previous file references in the `Manifest` files are removed, so
    that `repoman` does not think the digest can be skipped.
4.  New ebuilds are created, copied from the previous version. In these
    ebuilds, the `KEYWORDS` variable is updated to only contain
    `~arch` keywords.
5.  A release tag is created in the git repository.

Then the script tells the user to add the new files to the repository,
run `repoman manifest` and `repoman full` to verify the quality of the
ebuilds and generate the necessary digests. Then, and also after
testing, the created ebuilds can be committed to the repository.

The last few steps have explicitly not been automated so the developer
has the chance to update the ebuilds (in case more than just the policy
contents has changed between releases) or do dry runs without affecting
the `gentoo-x86` repository.
