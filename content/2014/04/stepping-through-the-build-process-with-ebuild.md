Title: Stepping through the build process with ebuild
Date: 2014-04-20 11:59
Category: Gentoo
Tags: ebuild, phase, portage
Slug: stepping-through-the-build-process-with-ebuild

Today I had to verify a patch that I pushed upstream but which was
slightly modified. As I don't use the tool myself (it was a
user-reported issue) I decided to quickly drum up a live ebuild for the
application and install it (as the patch was in the upstream repository
but not in a release yet). The patch is for
[fcron](http://fcron.free.fr/)'s SELinux support, so the file I created
is
[fcron-9999.ebuild](https://github.com/sjvermeu/gentoo.overlay/tree/master/sys-process/fcron).

Sadly, the build failed at the documentation generation (something about
"No targets to create en/HTML/index.html"). That's unfortunate, because
that means I'm not going to ask to push the live ebuild to the Portage
tree itself (yet). But as my primary focus is to validate the patch (and
not create a live ebuild) I want to ignore this error and go on. I don't
need the fcron documentation right now, so how about I just continue?

To do so, I start using the **ebuild** command. As the failure occurred
in the build phase (*compile*) and at the end (documentation was the
last step), I tell Portage that it should assume the build has
completed:

    ~# touch /var/portage/portage/sys-process/fcron-9999/.compiled

Then I tell Portage to install the (built) files into the `images/`
directory:

    ~# ebuild /home/swift/dev/gentoo.overlay/sys-process/fcron/fcron-9999.ebuild install

The installation phase fails again (with the same error as during the
build, which is logical as the `Makefile` can't install files that
haven't been properly build yet.) As documentation is the last step, I
tell Portage to assume the installation phase has completed as well,
continuing with the merging of the files to the life file system:

    ~# touch /var/portage/portage/sys-process/fcron-9999/.installed
    ~# ebuild /home/swift/dev/gentoo.overlay/sys-process/fcron/fcron-9999.ebuild qmerge

Et voila, `fcron-9999` is now installed on the system, ready to validate
the patch I had to check.
