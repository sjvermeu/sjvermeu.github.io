Title: More on initramfs and SELinux
Date: 2012-03-25 19:44
Category: Gentoo
Slug: more-on-initramfs-and-selinux

With the upcoming udev version *not* supporting separate `/usr`
locations unless you boot with an initramfs, we are
[now](https://bugs.gentoo.org/show_bug.cgi?id=407959)
[starting](https://bugs.gentoo.org/show_bug.cgi?id=408691)
[to](https://bugs.gentoo.org/show_bug.cgi?id=408971) document how to
create an initramfs to boot with. After all, systems with a separate
`/usr` are not that uncommon.

As I've blogged about
[before](http://blog.siphos.be/2012/01/trying-out-initramfs-with-selinux-and-grsec/),
getting an initramfs to work well with SELinux has not been an easy
drift. In effect, I'm going to push out the FAQ (the [Gentoo
wiki](http://wiki.gentoo.org/wiki/Knowledge_Base:Booting_SELinux_with_an_initramfs)
already has it) that the user will need to boot in permissive mode, and
have an init script in the boot runlevel that will reset the contexts of
`/dev` and then switch to enforcing mode. And those that want to make
sure SELinux stays on can then also enable the
*secure\_mode\_policyload* SELinux boolean so that you cannot go back to
permissive mode (without rebooting).

For those interested, this is the init script I use on my guest systems
(which are for development purposes, so they do not toggle the SELinux
boolean):

` #!/sbin/runscript # Copyright (c) 2007-2009 Roy Marples  # Released under the 2-clause BSD license.`

description="Switch into SELinux enforcing mode"

depend()  
{  
need localmount  
}

start()  
{  
ebegin "Restoring file contexts in /dev"  
restorecon -R /dev  
eend 0

ebegin "Switching to enforcing mode"  
setenforce 1  
eend \$?  
}  
</code>

I call it `selinux_enforce` for a lack of imagination (and to make it
more clear, because if I'd name it "wookie" I'll be scratching my head
in a few weeks trying to figure out why I did that in the first place).

With that enabled, I cannot provide a "denial-free" boot-up anymore
(you'll see many denials from the `init_t` domain, amongst others, which
are best not hidden). That is to say, until I take some time to patch
the initramfs to handle SELinux.

Oh, btw, this is for both dracut-generated as well as
genkernel-generated initramfs's. At least the technologies are
consistent there.
