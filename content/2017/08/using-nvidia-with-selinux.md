Title: Using nVidia with SELinux
Date: 2017-08-23 19:04
Category: SELinux
Tags: gentoo,selinux,nvidia
Slug: using-nvidia-with-selinux

Yesterday I've [switched to the gentoo-sources kernel package][1] on Gentoo Linux.
And with that, I also attempted (succesfully) to use the propriatary nvidia drivers
so that I can enjoy both a smoother 3D experience while playing minecraft, as well
as use the CUDA support so I don't need to use cloud-based services for small
exercises.

[1]: http://blog.siphos.be/2017/08/switch-to-gentoo-sources/

The move to nvidia was quite simple, as the [nvidia-drivers wiki article][2] on
the Gentoo wiki was quite easy to follow.

[2]: https://wiki.gentoo.org/wiki/NVidia/nvidia-drivers

<!-- PELICAN_END_SUMMARY -->

**Signing the modules**

One difference I found with the article (which I've promply changed) is that
the signing command, necessary to sign the Linux kernel modules so that they
can be loaded (as unsigned or wrongly signed modules are not allowed on the
system), was different.

It used to be as follows (example for a single module, it had to be repeated
for each affected kernel module):

```
~# perl /usr/src/linux/scripts/sign-file sha512 \
      /usr/src/linux/signing_key.priv \
      /usr/src/linux/signing_key.x509 \
      /lib/modules/4.12.5-gentoo/video/nvidia-uvm.ko
```

However, from version 4.3.3 onward (as also explained by this excellent
[Signed kernel module support article][3] on the Gentoo wiki) this command
no longer uses a Perl script, but is an ELF binary. Also, the location
of the default signing key is moved into a `certs/` subdirectory.

[3]: https://wiki.gentoo.org/wiki/Signed_kernel_module_support

**Enabling nvidia device files**

When the nvidia modules are loaded, additional device files are enabled.
One is the `nvidia0` character device file, while the other is the
`nvidiactl` character device file. And although I can imagine that the
`nvidiactl` one is a control-related device file, I don't exactly know
for sure.

However, attempts to use 3D applications showed (through SELinux denials)
that access to these device files is needed. Without that, applications just
crashed, like so:

```
org.lwjgl.LWJGLException: X Error - disp: 0x7fd164907b00 serial: 150 error: BadValue (integer parameter out of range for operation) request_code: 153 minor_code: 24
        at org.lwjgl.opengl.LinuxDisplay.globalErrorHandler(LinuxDisplay.java:320)
        at org.lwjgl.opengl.LinuxContextImplementation.nCreate(Native Method)
        at org.lwjgl.opengl.LinuxContextImplementation.create(LinuxContextImplementation.java:51)
        at org.lwjgl.opengl.ContextGL.<init>(ContextGL.java:132)
        at org.lwjgl.opengl.Display.create(Display.java:850)
        at org.lwjgl.opengl.Display.create(Display.java:757)
        at org.lwjgl.opengl.Display.create(Display.java:739)
        at bib.at(SourceFile:635)
        at bib.aq(SourceFile:458)
        at bib.a(SourceFile:404)
        at net.minecraft.client.main.Main.main(SourceFile:123)
```

Not really useful to debug for me, but the SELinux denials were a bit more obvious,
showing requests for read and write to the `nvidiactl` character device.

Thanks to `matchpathcon` I found out that the device files had to have the
`xserver_misc_device_t` type (which they didn't have to begin with, as the device
files were added after the automated `restorecon` was done on the `/dev` location).

So, adding the following command to my local init script fixed the context setting
at boot up:

```
restorecon /dev/nvidiactl /dev/nvidia0
```

Also, the domains that needed to use nVidia had to receive the following
addition SELinux-policy-wise:

```
dev_rw_xserver_misc(...)
```

Perhaps this can be made more fine-grained (as there are several other device
files marked as `xserver_misc_device_t`) but for now this should suffice.

**Optimus usage with X server**

The other challenge I had was that my workstation uses an integrated Intel
device, and offloads calculations and rendering to nVidia. The detection by
X server did not work automatically though, and it took some fiddling to get
it to work.

In the end, I had to add in an `nvidia.conf` file inside `/etc/X11/xorg.conf.d`
with the following content:

```
Section "ServerLayout"
        Identifier      "layout"
        Screen  0       "nvidia"
        Inactive        "intel"
EndSection

Section "Device"
        Identifier      "nvidia"
        Driver          "nvidia"
        BusID           "PCI:1:0:0"
EndSection

Section "Screen"
        Identifier      "nvidia"
        Device          "nvidia"
        Option          "AllowEmptyInitialConfiguration"
EndSection

Section "Device"
        Identifier      "intel"
        Driver          "modesetting"
EndSection

Section "Screen"
        Identifier      "intel"
        Device          "intel"
EndSection
```

And with a single `xrandr` command I re-enabled split screen support (as by
default it now showed the same output on both screens):

```
~$ xrandr --output eDP-1-1 --left-of HDMI-1-2
```

I also had to set the output source to the nVidia device, by adding the following
lines to my `~/.xinitrc` file:

```
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
```

And with that, another thing was crossed off from my TODO list. Which has become
quite large after my holidays (went to Kos, Greece) as I had many books and articles
on my ebook reader with me, which inspired a lot.

