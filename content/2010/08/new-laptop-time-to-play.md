Title: New laptop, time to play
Date: 2010-08-13 01:33
Category: Free Software
Slug: new-laptop-time-to-play

I gave myself a nice treat and bought a new laptop. After some
consideration, I decided to go with the HP Pavilion DV7 3150EB. Years
ago, I didn't take an HP laptop as the reviews were not that satisfying.
However, it looks as if that is past. So I first took a stab at the
[Gentoo Quickinstall for LVM2 and
RAID](http://www.gentoo.org/doc/en/gentoo-x86+raid+lvm2-quickinstall.xml)
and gave myself a (software) RAID-1 system with everything except / and
/boot using LVM2. To my satisfaction, following the guide was a breeze
and it worked out just fine.

The real hurdle, that I just won, was to get the wireless up and running
on WPA2. I noticed earlier (before I bought the laptop) that getting the
Broadcom 43255 wifi (Broadcom Corporation Device 4357 (rev 01)) might be
a challenge. Well, the open-source b43 driver didn't detect the wifi
card, but the (closed-source) Broadcom STA driver (as supported by
Broadcom itself) does. To install it on Gentoo, it was as easy as
unmasking *broadcom-sta* and installing it. It worked immediately, but
not for WPA/WPA2 networks (and I am not going to put my wireless in
non-WPA2 mode). Luckily, it was easy to discover that it was
*wpa\_supplicant* itself that was giving the card a hard time as non-WPA
networks worked flawlessly. A quick stab at the `wpa_supplicant.conf`
file gave me the final success I needed: *ap\_scan=2* did the trick.

Tomorrow: getting the webcam working...
