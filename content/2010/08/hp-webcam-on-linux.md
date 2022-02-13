Title: HP webcam on Linux
Date: 2010-08-13 18:18
Category: Free-Software
Slug: hp-webcam-on-linux

Okay, getting the HP webcam running on Linux wasn't hard at all. Enable
Video For Linux (CONFIG\_VIDEO\_DEV) which can be found in the Linux
kernel configuration at Device Drivers, Multimedia Support. Then, select
Video capture adapters and inside that menu, select V4L USB devices and
then USB Video Class (UVC). Once installed, reboot (or load the kernel
module) and ensure that your user is in the video group. You'll then be
able to activate the webcam (for instance, using **mplayer tv://** or
using skype).

The integrated microphone is also no problem. It is by default muted, so
using **alsamixer**, press F4 (to get to the capture menu) and unmute
the channels + enable capturing (press spacebar).
