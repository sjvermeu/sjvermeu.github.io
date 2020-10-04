Title: Get your devtmpfs ready
Date: 2012-04-07 22:10
Category: Gentoo
Slug: get-your-devtmpfs-ready

If you are using stable profiles, you might want to verify if you are
already running a kernel with devtmpfs support enabled. Why? Well,
currently you might not need it, but the upcoming openrc/udev packages
require it and they currently do not fail at install time if you have it
enabled or not. As a result, upgrading these packages might give you a
system that might fail to boot (if you have no initramfs but separate
/usr partition) or gives many errors (if you have an initramfs).

To verify if it is enabled, check your kernel configuration:

` # zgrep DEVTMPFS /proc/config.gz # CONFIG_DEVTMPFS is not set`

If you get the output as described above, best update your kernel
configuration to include it. The second devtmpfs-related option (to
automatically mount it on /dev) is not needed afaik.

And for those that have been with Gentoo for a while - devtmpfs is not
devfs. Well, it is. But it isn't. Somewhat. Oh well, there's discussion
on that which I'm not going to elaborate on. Safe to say that we're
getting older if we start feeling "Been there, done that, got the
t-shirt" ;-)

*Edit:* as Robin mentioned in the comments, the udev ebuild does check
at it. However, it doesn't fail an installation so you could miss the
message. Apologies for the lies, Robin ;-) Post updated.
