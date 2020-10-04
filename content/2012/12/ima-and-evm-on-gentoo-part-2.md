Title: IMA and EVM on Gentoo, part 2
Date: 2012-12-29 23:42
Category: Gentoo
Slug: ima-and-evm-on-gentoo-part-2

I have been playing with [Linux
IMA/EVM](https://sourceforge.net/apps/mediawiki/linux-ima/index.php?title=Main_Page)
on a Gentoo Hardened (with SELinux) system for a while and have been
documenting what I think is interesting/necessary for Gentoo Linux users
when they want to use IMA/EVM as well. Note that the documentation of
the Linux IMA/EVM project itself is very decent. It's all on a single
wiki page, but it's decent and I learned a lot from it.

That being said, I do have the impression that the method they suggest
for generating IMA hashes for the entire system is not always working
properly. It might be because of SELinux on my system, but for now I'm
searching for another method that does seem to work well (I'm currently
trying my luck with a **find ... -exec evmctl** based command). But once
the hashes are registered, it works pretty well (well, there's a
probably small SELinux problem where loading a new policy or updating
the existing policies seems to generate stale rules and I have to reboot
my system, but I'll find the culprit of that soon ;-)

The [IMA
Guide](http://www.gentoo.org/proj/en/hardened/integrity/docs/ima-guide.xml)
has been updated to reflect recent findings - including how to load a
custom policy, and I have also started on the [EVM
Guide](http://www.gentoo.org/proj/en/hardened/integrity/docs/evm-guide.xml).
I think it'll take me a day or three to finish off the rough edges and
then I'll start creating a new SELinux node (KVM) image that users can
use with various Gentoo Hardened-supported technologies enabled (PaX,
grSecurity, SELinux, IMA and EVM).

So if you're curious about IMA/EVM and willing to try it out on Gentoo
Linux, please have a look at those documents and see if they assist you
(or confuse you even more).
