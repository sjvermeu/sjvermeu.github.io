Title: Temporary script for Gentoo Hardened SELinux users
Date: 2011-02-27 17:37
Category: SELinux
Slug: temporary-script-for-gentoo-hardened-selinux-users

If you are currently using Gentoo Hardened with SELinux, you might have
noticed that we are currently lacking the proper dependencies within our
Portage tree upon the SELinux policies (or, in other words, installing a
package doesn't guarantee that the SELinux policy needed for that
package is pulled in as well). As the current SELinux policy is still in
\~arch phase, it is also not really feasible to ask other package
maintainers to add the proper dependency information as that might stall
potential stability requests in general.

So, for the time being, I'm using a simple script (which I call
[genmodoverview](https://github.com/sjvermeu/small.coding/tree/master/genmodoverview))
which tells me on my systems which SELinux policy modules i might still
be missing. Based on the output of that script, I can then continue to
install the `sec-policy/selinux-*` package(s) for those modules.

It's usage is simple. Download the genmodoverview.sh and LISTING files,
make the first one executable and run **./genmodoverview.sh -c
LISTING**.
