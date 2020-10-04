Title: emerge-webrsync and gpg verification
Date: 2011-07-22 14:33
Category: Gentoo
Slug: emerge-webrsync-and-gpg-verification

Gentoo has been working on its
[security](http://www.gentoo.org/proj/en/glep/glep-0057.html) from very
early on. One of the (many) features it supports is to allow users to
validate the state of the portage tree. Ebuild signing (where developers
sign the Manifest file with their key) is one of the layers offered by
Gentoo, but another one is full tree signing.

When you use **emerge-webrsync** instead of **emerge --sync**, an
archive containing a consistent state of the portage tree is downloaded
and unpacked on your system. If you however set
`FEATURES="webrsync-gpg"` then this tool will check the GPG signature
attached to the file with the public key used by Gentoo's infrastructure
(0x239C75C4). If the archive does not contain a valid signature, then it
is not used on the system.

If you want to use this, here are the steps to do so.

First, set up the location where you keep the key:

    ~# mkdir -p /etc/portage/gpg
    ~# gpg --homedir /etc/portage/gpg --keyserver subkeys.pgp.net --recv-keys 0x239C75C4
    ~# gpg --homedir /etc/portage/gpg --edit-key 0x239C75C4 trust

Next, edit `/etc/make.conf` and set the following parameters:

    FEATURES="webrsync-gpg"
    PORTAGE_GPG_DIR="/etc/portage/gpg"
    # Disable 'emerge --sync' so emerge-webrsync has to be used
    SYNC=""

With that done, you're all set. Just run **emerge-webrsync**.

Happy Gentooing!
