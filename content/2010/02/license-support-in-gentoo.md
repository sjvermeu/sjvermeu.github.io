Title: License support in Gentoo
Date: 2010-02-16 00:10
Category: Gentoo
Slug: license-support-in-gentoo

It's a bit sad that Gentoo didn't promote this more, but Gentoo users
now have support for license-based masking.

What does this mean? Well, previously, Gentoo already supported various
masking reasons (like stable versus staging - the x86 versus \~x86 saga,
package.mask'ing - for security reasons or critical bugs, ...). Now, a
new feature is added: license masking.

By default, Portage accepts all non-EULA licenses. If a package uses a
EULA license, you'll get a failure message stating that the license is
'masked'.

Now, what good does this do for users? Well, you can now ask Portage
only to accept certain licenses (like `@FSF-APPROVED`, which is a list
of all FSF-approved licenses) and deny the installation of others. Nice,
isn't it?

I've added information regarding package license states (and the global
as well as per-package unmasking support through
/etc/portage/package.license) to the [Linux
Sea](http://swift.siphos.be/linux_sea) document.
