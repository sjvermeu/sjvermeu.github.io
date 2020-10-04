Title: Rebuilding SELinux contexts with sefcontext_compile
Date: 2013-07-08 20:55
Category: SELinux
Tags: hardened, pcre, selinux
Slug: rebuilding-selinux-contexts-with-sefcontext_compile

A recent update of *libpcre* caused the binary precompiled regular
expression files of SELinux to become outdated (and even blatantly
wrong). The details are in bug [471718](https://bugs.gentoo.org/471718)
but that doesn't help the users that are already facing the problem, nor
have we found a good place to put the fix in.

Anyway, if you are facing issues with SELinux labeling (having files
being labeled as *portage\_tmp\_t* instead of the proper label), check
with **matchpathcon** if the label is correct. If **matchpathcon** sais
that the label should be `<<none>>` then you need to rebuild the SELinux
context files:

    # cd /etc/selinux/strict/contexts/files
    # for n in *.bin; do sefcontext_compile ${n%%.bin}; done

The **sefcontext\_compile** command will rebuild the SELinux context
files. When that has been done, **matchpathcon** should show the right
context again, and Portage will relabel files correctly. Until then, you
will need to relabel the packages that have been built since (and
including) the *libpcre* build.

If someone has a good suggestion where to put these rebuilds in, please
do drop a note in the bug. Although the proper one might be *libpcre*
itself, I'd rather not put too much SELinux logic in the ebuild unless
it is pretty safeguarded...

In any case, it has also been documented in the [Gentoo SELinux
FAQ](https://wiki.gentoo.org/wiki/SELinux/FAQ#File_labels_do_not_seem_to_be_set_anymore.2C_and_matchpathcon_sais_.3C.3Cnone.3E.3E)
on the Gentoo wiki.
