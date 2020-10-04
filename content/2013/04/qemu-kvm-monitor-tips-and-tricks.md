Title: Qemu-KVM monitor tips and tricks
Date: 2013-04-30 03:50
Category: Free Software
Tags: kvm, monitor, qemu
Slug: qemu-kvm-monitor-tips-and-tricks

When running KVM guests, the [Qemu/KVM
monitor](https://en.wikibooks.org/wiki/QEMU/Monitor) is a nice interface
to interact with the VM and do specific maintenance tasks on. If you run
the KVM guests with VNC, then you can get to this monitor through
`Ctrl-Alt-2` (and `Ctrl-Alt-1` to get back to the VM display). I
personally run with the monitor on the standard input/output where the
VM is launched as its output is often large and scrolling in the VNC
doesn't seem to work well.

I decided to give you a few tricks that I use often on the monitor to
handle the VMs.

When I do not start the VNC server associated with the VM by default, I
can enable it on the monitor using **change vnc** while getting details
is done using **info vnc**. To disable VNC again, use **change vnc
none**.

    (qemu) info vnc
    Server: disabled
    (qemu) change vnc 127.0.0.1:20
    (qemu) change vnc password
    Password: ******
    (qemu) info vnc
    Server:
         address: 127.0.0.1:5920
            auth: vnc
    Client: none

Similarly, if you need to enable remote debugging, you can use the
**gdbserver** option.

Getting information using **info** is dead-easy, and supports a wide
area of categories: balloon info, block devices, character devices,
cpus, memory mappings, network information, etcetera etcetera... Just
enter **info** to get an overview of all supported commands.

To easily manage block devices, you can see the current state of devices
using **info block** and then use **change &lt;blockdevice&gt;
&lt;path&gt;** to update it.

    (qemu) info block
    virtio0: removable=0 io-status=ok file=/srv/virt/gentoo/hardened2selinux/selinux-base.img ro=0 drv=qcow2 encrypted=0 bps=0 bps_rd=0 bps_wr=0 iops=0 iops_rd=0 iops_wr=0
    ide1-cd0: removable=1 locked=0 tray-open=0 io-status=ok [not inserted]
    floppy0: removable=1 locked=0 tray-open=0 [not inserted]
    sd0: removable=1 locked=0 tray-open=0 [not inserted]
    (qemu) change ide1-cd0 /srv/virt/media/systemrescuecd-x86-2.2.0.iso

To powerdown the system, use **system\_powerdown**. If that fails, you
can use **quit** to immediately shut down (terminate) the VM. To reset
it, use **system\_reset**. You can also hot-add PCI devices and
manipulate CPU states, or even perform [live
migrations](http://www.linux-kvm.org/page/Migration) between systems.

When you use qcow2 image formats, you can take a full VM snapshot using
**savevm** and, when you later want to return to this point again, use
**loadvm**. This is interesting when you want to do potentially harmful
changes on the system and want to easily revert back if things got
broken.

    (qemu) savevm 20130419
    (qemu) info snapshots
         ID        TAG                 VM SIZE                DATE       VM CLOCK
         1         20130419               224M 2013-04-19 12:05:16   00:00:17.294
    (qemu) loadvm 20130419
