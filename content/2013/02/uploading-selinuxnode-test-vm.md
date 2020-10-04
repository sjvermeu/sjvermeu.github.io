Title: Uploading selinuxnode test VM
Date: 2013-02-25 03:05
Category: Gentoo
Tags: evm, Gentoo, grsecurity, hardened, ima, kvm, selinux, virtual
Slug: uploading-selinuxnode-test-vm

At the time of writing (but I'll delay the publication of this post a
few hours), I'm uploading a new SELinux-enabled KVM guest image. This is
not an update on the previous image though (it's a reinstalled system -
after all, I use VMs for testing, so it makes sense to reinstall from
time to time to check if the installation instructions are still
accurate). However, the focus remains the same:

-   A minimal Gentoo Linux installation for amd64 (x86\_64) as guest
    within a KVM hypervisor. The image is about 190 Mb in size
    compressed, and 1.6 Gb in size uncompressed. The file format is
    Qemu's QCOW2 so expect the image to grow as you work with it. The
    file systems are, in total, sized to about 50 Gb.
-   The installation has SELinux enabled (strict policy, enforcing
    mode), various grSecurity settings enabled (including PaX and TPE),
    but now also includes IMA (Integrity Measurement Architecture) and
    EVM (Extended Verification Module) although EVM is by default
    started in fix mode.
-   The image will not start any network-facing daemons by default
    (unlike the previous image) for security reasons (if I let this
    image stay around this long as I did with the previous, it's prone
    to have some vulnerabilities in the future, although I'm hoping I
    can update the image more frequently). This includes SSH, so you'll
    need access to the image console first after which you can configure
    the network and start SSH (**run\_init rc-service sshd start** does
    the trick).
-   A couple of default accounts are created, and the image will display
    those accounts and their passwords on the screen (it is a test/play
    VM, not a production VM).

There are still a few minor issues with it, that I hope to fix by the
next upload:

-   [Bug 457812](https://bugs.gentoo.org/show_bug.cgi?id=457812) is
    still applicable to the image, so you'll notice lots of SELinux
    denials on the mknod capability. They seem to be cosmetic though.
-   At shutdown, udev somewhere fails with a SELinux initial
    context problem. I thought I had it covered, but I noticed after
    compressing the image that it is still there. I'll fix it - I
    promise ;)
-   EVM is enabled in fix mode, because otherwise EVM is [prohibiting
    mode
    changes](http://sourceforge.net/mailarchive/forum.php?thread_name=1361476641.29360.114.camel%40falcor1&forum_name=linux-ima-user)
    on files in /run. I still have to investigate this further though -
    I had to use the EVM=fix workaround due to time pressure.

When uploaded, I'll ask the Gentoo infrastructure team to synchronise
the image with our mirrors so you can enjoy it. It'll be on the
distfiles, under experimental/amd64/qemu-selinux (it has the 20130224
date in the name, so you can see for yourself if the sync has already
occurred or not).
