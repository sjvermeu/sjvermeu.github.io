Title: Some things sound more scary than they are
Date: 2013-08-15 10:02
Category: SELinux
Tags: android, grsecurity, pax, selinux, tablet
Slug: some-things-sound-more-scary-than-they-are

A few days ago I finally got to the next thing on my *Want to do this
year* list: put a new android
([Cyanogenmod](http://www.cyanogenmod.org/)) on my tablet, which was
still running the stock Android - but hasn't seen any updates in more
than a year. Considering the (in)security of Android this was long
overdue for me. But the fear of getting an unbootable tablet ("bricked"
as it is often called) was keeping me from doing so.

So when I finally got the nerves, I first had to run around screaming
for hours because the first step in the instructions didn't work. The
next day I read that it might have to do with the cable - and indeed,
tried with a different cable and the instructions just went along just
fine. So today I'm happily running with a more up-to-date Android again
on my tablet.

Because my systems run Gentoo Hardened with SELinux, I did had to do
some small magic tricks to get the
[Clockworkmod](http://www.clockworkmod.com/) recovery on the tablet: the
**wheelie** binary (yes, I couldn't find the sources - if they are even
available) that I had to run required me to disable size overflow
detection in the kernel (a PaX countermeasure), allowed executable
memory (both through **paxctl-ng** as well as in SELinux using the
`allow_execmem` boolean) and had to temporarily add in the
`dev_rw_generic_usb_dev` right (refpolicy macro) to my user.

Also **adb** had to be pax-marked, although I now know I don't need
**adb** at all - I can just download the latest Android ZIP file from
the phone itself and refer to it from the recovery manager.

All in all nothing to worry about - everything worked like a charm.

*Edit:* (so I remember next time), if the system is stuck in CMR
(recovery), reboot with VolDown+Pwr, but don't select recovery. After 5
seconds, it will ask if you want a cold boot. Select it, and things work
again ;-)
