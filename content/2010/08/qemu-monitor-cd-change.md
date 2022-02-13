Title: qemu monitor cd change
Date: 2010-08-30 21:38
Category: Free-Software
Slug: qemu-monitor-cd-change

I've been playing around with kvm (which uses qemu) to try out other
operating systems and Linux distributions. Up until now, little progress
on that part (not because it is difficult, just little time) but there
are a few things worth mentioning. For this post, let's start with a
quicky on CD changes.

qemu's integrated monitor is very nice and powerful. To go to the
monitor from inside the vnc session, press Ctrl+Alt+2 (to go back, use
Ctrl+Alt+1). Then you can query for attached hardware, add new devices,
remove others, cpu's, etc. Something I found necessary was to switch
CD/DVD images. With `info block` I found the device. I then ran
`eject ide1-cd0` followed by `change ide1-cd0 /path/to/new/image` et
voila, new CD available.
