Title: Switched to Lineage OS
Date: 2017-04-09 16:40
Category: Misc
Tags: cyanogenmod, lineageos, mobile, android
Slug: switched-to-lineage-os

I have been a long time user of [Cyanogenmod](https://en.wikipedia.org/wiki/CyanogenMod), 
which discontinued its services end of 2016. Due to lack of (continuous) time, I was not
able to switch over toward a different ROM. Also, I wasn't sure if
[LineageOS](https://www.lineageos.org/) would remain the best choice for me or not. I wanted
to review other ROMs for my Samsung Galaxy SIII (the i9300 model) phone.

Today, I made my choice and installed LineageOS.

<!-- PELICAN_END_SUMMARY -->

**The requirements list**

When looking for new ROMs to use, I had a number of requirements, some must-have, others
should-have or would-have (using the [MoSCoW method](https://en.wikipedia.org/wiki/MoSCoW_method).

First of all, I want the ROM to be installable through ClockworkMod 6.4.0.something. This
is a mandatory requirement, because I don't want to venture out in installing a different
recovery (like [TWRP](https://twrp.me/)). Not that much that I'm scared from it, but it might
require me to install stuff like Heimdal and update my SELinux policies on my system to allow
it to run, and has the additional risk that things still fail.

I tried updating the recovery ROM in the past (a year or so ago) using the mobile application
approaches themselves (which require root access, that my phone had at the time) but it continuously
said that it failed and that I had to revert to the more traditional way of flashing the
recovery.

Given that I know I need to upgrade within a day (and have other things planned today) I didn't
want to loose too much time in upgrading the recovery first.

Second, the ROM had to allow OTA updates. With CyanogenMod, the OTA didn't fully work on
my phone (it downloaded and verified the images correctly, but couldn't install it
automatically - I had to reboot in recovery manually and install the ZIP), but it worked
sufficiently for me to easily update the phone on a weekly basis. I wanted to keep this luxury,
and who knows, move towards an end-to-end working OTA.

Furthermore, the ROM had to support Android 7.1. I want the latest Android to see how long
this (nowadays aged) phone can handle things. Once the phone cannot get the latest Android
anymore, I'll probably move towards a new phone. But as long as I don't have to, I'll put
my money in other endeavours ;-)

Finally, the ROM must be in active development. One of the reasons I want the latest Android
is also because I want to keep receiving the necessary security fixes. If a ROM doesn't
actively follow the security patches and code, then it might become (too) vulnerable for
comfort.

**ROMs, ROMs everywhere (?)**

First, I visited the [Galaxy S3 discussion](https://forum.xda-developers.com/galaxy-s3/development)
on the XDA-Developers site. This often contains enough material to find ROMs which have 
a somewhat active development base.

I was still positively surprised by the activity on this quite old phone (the i9300 was
first released in May, 2012, making this phone almost 5 years old).

The [Vanir](https://forum.xda-developers.com/galaxy-s3/development/vanir-aosp-t3568393)
mod seemed to imply that TWRP was required, but past articles on Vanir showed that CWM
should also work. However, from the discussion I gathered that it is based on LineageOS.
Not that that's bad, but it makes LineageOS the "preferred" ROM first (default installed
software list, larger upstream community, etc.)

The [Ressurrection Remix](http://forum.resurrectionremix.com/)
shows a very active discussion with good feedback from the developer(s). It is based on
a number of other resources (including CyanogenMod), so seems to borrow and implement
various other features. Although I got the slight impression that it would be a bit more
filled with applications I might not want, I kept it on the short-list.

[SLIMROM](https://forum.xda-developers.com/galaxy-s3/development/slimrom-t3580824) is
based on AOSP (the Android Open Source Project). It doesn't seem to support OTA though,
and its release history is currently still premature. However, I will keep an eye on this
one for future reference.

After a while, I started looking for ROMs based on AOSP, as the majority of ROMs shown
are based on LineageOS (abbreviated to LOS). Apparently, for the Samsung S3, LineageOS
seems to be one of the most popular sources (and ROMs).

So I put my attention to LineageOS:

* It [supports CWM installations](https://lineageosrom.org/install-lineageos-cwm/)
* It offers OTA update support
* It closely tracks upstream
* It is in active development

So, why not?

**Using LineageOS without root**

While deciding to use LineageOS or go through with additional ROM seeking, I stumbled
upon the installation instructions that showed that the ROM can be installed without
automatically enabling rooted Android access. I'm not sure if this was the case with
Cyanogenmod (I've been running with a rooted Cyanogenmod for too long to remember) but
it opened a possiblity for me...

Personally, I don't mind having a rooted phone, as long as it is the user who decides
which applications can get root access and which can't. For me, the two applications
that used root access was an open source ad blocker called [AdAway](https://adaway.org/)
and the Android shell (for troubleshooting purposes, such as killing the media server
if it locked my camera).

But some applications seem to think that a rooted phone automatically means that the
phone is open access and full of malware. It is hard to find any trustworthy, academical
research on the actual secure state of rooted versus non-rooted devices. I believe 
that proper application vetting (don't install applications that aren't popular
and long-existing, check the application vendors, etc.) and keeping your phone up-to-date
is much more important than not rooting.

And although these applications happily function on old, unpatched Android 4.x devices
they refuse to function on my (rooted) Android 7.1 phone. So, the ability to install
LineageOS without root (rooting actually requires flashing an additional package) is
a nice thing as I can start with a non-rooted device first, and switch back to a rooted
device if I need it later.

With that, I decided to flash my phone with the latest LineageOS nightly for my phone.

**Switching password manager**

I tend to use such ROM switches (or, in case of CyanogenMod, major version upgrades)
as a time to revisit the mobile application list, and reduce it to what I really used
the last few months.

One of the changes I did on my mobile application list is switch the password application.
I used to use [Remember Passwords](https://play.google.com/store/apps/details?id=ebeletskiy.gmail.com.passwords)
but it hasn't seen updates for quite some time, and the backup import failed last
time I migrated to a higher CyanogenMod version (possibly Android version related).
Because I don't want to synchronize the passwords or see the application have any Internet
oriented activity, I now use [Keepass2Android Offline](https://play.google.com/store/apps/details?id=keepass2android.keepass2android_nonet).

This is for passwords which I don't auto-generate using [SuperGenPass](https://chriszarate.github.io/supergenpass/),
my favorite password manager. I don't use the bookmarklet approach myself, but download
and run it separately when generating passwords - or use a [SuperGenPass mobile application](https://play.google.com/store/apps/details?id=info.staticfree.SuperGenPass&hl=en).

**First impressions**

It is too soon to say if it is fully functional or not. Most standard functionality
works OK (phone, SMS, camera) but it is only after a few days that specific issues
can come up.

Only the first boot was very slow (probably because it was optimizing the application
list in the background), the second boot was well below half a minute. I didn't count it,
but it's fast enough for me.


