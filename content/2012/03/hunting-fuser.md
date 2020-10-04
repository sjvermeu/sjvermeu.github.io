Title: Hunting fuser
Date: 2012-03-12 21:54
Category: Gentoo
Slug: hunting-fuser

I am able to work on Gentoo and SELinux about one hour per day. It's
more in total time, but being a bit exhausted makes me act a bit more
slowly which boils down to about one hour per day. And one hour per day
isn't bad, you're able to do many things in that hour.

The last few days, I've been hunting SELinux denials. I've set my mind
onto releasing the 2.20120215-r5 policy only when I've been able to boot
a minimalistic Gentoo installation without any visible denials, so
either dontaudit them or fix them. Of course, I only want to allow if
I'm absolutely confident that they are needed on some systems, but I
also only want to dontaudit when I understand what it is doing (and find
that it isn't something needed).

Some of the denials are driving me up the walls, often having an entire
evening hunting for a single one... and this is why you haven't seen
many updates since a week or so. The one I'm hunting now, is shown in
the logs as follows:

    Mar 12 20:21:32 testsys kernel: [    6.550618] type=1400 audit(1331580090.874:4): avc:  denied  { getattr } 
      for  pid=1512 comm="fuser" path="socket:[3159]" dev=sockfs ino=3159 
      scontext=system_u:system_r:initrc_t tcontext=system_u:system_r:udev_t tclass=unix_stream_socket
    Mar 12 20:21:32 testsys kernel: [    6.551232] type=1400 audit(1331580090.875:5): avc:  denied  { getattr }
      for  pid=1513 comm="fuser" path="socket:[3160]" dev=sockfs ino=3160
      scontext=system_u:system_r:initrc_t tcontext=system_u:system_r:udev_t tclass=netlink_kobject_uevent_socket
    Mar 12 20:21:32 testsys kernel: [    6.562005] type=1400 audit(1331580090.885:6): avc:  denied  { getattr }
      for  pid=1530 comm="fuser" path="socket:[3705]" dev=sockfs ino=3705
      scontext=system_u:system_r:initrc_t tcontext=system_u:system_r:udev_t tclass=netlink_kobject_uevent_socket
    ... (these netlink_kobject_uevent_socket ones are repeated a few times)

I have *no idea* who (or what) is executing fuser to find some
information. The shown PIDs are those of fuser, and of course that isn't
running anymore when the system is booted. The timeframe shown also
doesn't seem to provide much information, because it is the time that it
is logged by the system logger apparently (I once hoped I was wrong
here, but repeated tests and introducing delays and such seems to
confirm it). And because the target is on dev=sockfs, it's hardly
something I'm able to actively search for.

Or at least that I know of.

The source context is initrc\_t, so it is started from an init script.
And the target is always udev\_t, so it might be triggered by the udev
(or a udev-related) init script (as it seems to only look for these of
udev, but that might be a coincidence). But alas, I still don't know
what is calling it as I can't find a script or udev rule that calls
fuser :-( It doesn't affect the runtime behavior of my system
(everything seems to work just fine) so I might go on and dontaudit it.
But I so want to know what this is about.

To be continued...
