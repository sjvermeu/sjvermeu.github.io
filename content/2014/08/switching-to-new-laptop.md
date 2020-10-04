Title: Switching to new laptop
Date: 2014-08-19 22:11
Category: Gentoo
Tags: efi, Gentoo, laptop
Slug: switching-to-new-laptop

I'm slowly but surely starting to switch to a new laptop. The old one
hasn't completely died (yet) but given that I had to force its CPU
frequency at the lowest Hz or the CPU would burn (and the system
suddenly shut down due to heat issues), and that the connection between
the battery and laptop fails (so even new battery didn't help out) so I
couldn't use it as a laptop... well, let's say the new laptop is welcome
;-)

Building Gentoo isn't an issue (having only a few hours per day to work
on it is) and while I'm at it, I'm also experimenting with EFI
(currently still without secure boot, but with EFI) and such.
Considering that the Gentoo Handbook needs quite a few updates (and I'm
thinking to do more than just small updates) knowing how EFI works is a
Good Thing (tm).

For those interested - the [EFI stub
kernel](https://wiki.gentoo.org/wiki/EFI_stub_kernel) instructions in
the article on the wiki, and also in Greg's wonderful post on [booting a
self-signed Linux
kernel](http://kroah.com/log/blog/2013/09/02/booting-a-self-signed-linux-kernel/)
(which I will do later) work pretty well. I didn't try out the "Adding
more kernels" section in it, as I need to be able to (sometimes) edit
the boot options (which isn't easy to accomplish with EFI
stub-supporting kernels afaics). So I installed
[Gummiboot](https://wiki.gentoo.org/wiki/Gummiboot) (and created a wiki
article on it).

Lots of things still planned, so little time. But at least building
chromium is now a bit faster - instead of 5 hours and 16 minutes, I can
now enjoy the newer versions after little less than 40 minutes.
