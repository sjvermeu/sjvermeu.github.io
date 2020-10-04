Title: Had to edit /etc/init.d/root
Date: 2012-06-24 15:38
Category: Gentoo
Slug: had-to-edit-etcinit-droot

For some reason, I had to edit my /etc/init.d/root file to use "mount
/dev/root -n -o remount,rw /" instead of the standard "mount -n -o
remount,rw /". Without this, it failed to remount the root file system
in a read-write mode, which is of course not that funny...
