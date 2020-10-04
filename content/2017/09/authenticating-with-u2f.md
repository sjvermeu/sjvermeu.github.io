Title: Authenticating with U2F
Date: 2017-09-11 18:25
Category: Security
Tags: gentoo,security,yubico,u2f,pam
Slug: authenticating-with-u2f

In order to further secure access to my workstation, after the [switch to Gentoo
sources][1], I now enabled two-factor authentication through my Yubico U2F
USB device. Well, at least for local access - remote access through SSH requires
both userid/password as well as the correct SSH key, by [chaining authentication
methods in OpenSSH][2].

[1]: http://blog.siphos.be/2017/08/switch-to-gentoo-sources/
[2]: https://lwn.net/Articles/544640/

Enabling U2F on (Gentoo) Linux is fairly easy. The various guides online which talk
about the `pam_u2f` setup are indeed correct that it is fairly simple. For completeness
sake, I've documented what I know on the Gentoo Wiki, as the [pam\_u2f article][3].

[3]: https://wiki.gentoo.org/wiki/Pam_u2f

<!-- PELICAN_END_SUMMARY -->

**The setup, basically**

The setup of U2F is done in a number of steps:
1. Validate that the kernel is ready for the USB device
2. Install the PAM module and supporting tools
3. Generate the necessary data elements for each user (keys and such)
4. Configure PAM to require authentication through the U2F key

For the kernel, the configuration item needed is the raw HID device support.
Now, in current kernels, two settings are available that both talk about
raw HID device support: `CONFIG_HIDRAW` is the general raw HID device support,
while `CONFIG_USB_HIDDEV` is the USB-specific raw HID device support.

It is very well possible that only a single one is needed, but both where active
on my kernel configuration already, and Internet sources are not clear which one is
needed, so let's assume for now both are.

Next, the PAM module needs to be installed. On Gentoo, this is a matter of installing
the `pam\_u2f` package, as the necessary dependencies will be pulled in automatically:

```
~# emerge pam_u2f
```

Next, for each user, a registration has to be made. This registration is needed for the
U2F components to be able to correctly authenticate the use of a U2F key for a particular
user. This is done with `pamu2fcfg`:

```
~$ pamu2fcfg -u<username> > ~/.config/Yubico/u2f_keys
```

The U2F USB key must be plugged in when the command is executed, as a succesful keypress (on the
U2F device) is needed to complete the operation.

Finally, enable the use of the `pam\_u2f` module in PAM. On my system, this is done
through the `/etc/pam.d/system-local-login` PAM configuration file used by all
local logon services.

```
auth     required     pam_u2f.so
```

**Consider the problems you might face**

When fiddling with PAM, it is important to keep in mind what could fail. During the setup, it
is recommended to have an open administrative session on the system so that you can validate if
the PAM configuration works, without locking yourself out of the system.

But other issues need to be considered as well.

My Yubico U2F USB key might have a high MTBF (Mean Time Between Failures) value, but once it fails,
it would lock me out of my workstation (and even remote services and servers that use it). For
that reason, I own a second one, safely stored, but is a valid key nonetheless for my workstation
and remote systems/services. Given the low cost of a simple U2F key, it is a simple solution for
this threat.

Another issue that could come up is a malfunction in the PAM module itself. For me, this is handled
by having remote SSH access done without this PAM module (although other PAM modules are still involved,
so a generic PAM failure itself wouldn't resolve this). Of course, worst case, the system needs to be
rebooted in single user mode.

One issue that I faced was the SELinux policy. Some applications that provide logon services don't have
the proper rights to handle U2F, and because PAM just works in the address space (and thus SELinux
domain) of the application, the necessary privileges need to be added to these services. My initial
investigation revealed the following necessary policy rules (refpolicy-style);

```
udev_search_pids(...)
udev_read_db(...)
dev_rw_generic_usb_dev(...)
```

The first two rules are needed because the operation to trigger the USB key uses the udev tables
to find out where the key is located/attached, before it interacts with it. This interaction is then
controlled through the first rule.

**Simple yet effective**

Enabling the U2F authentication on the system is very simple, and gives a higher confidence that
malicious activities through regular accounts will have it somewhat more challenging to switch to
a more privileged session (one control is the SELinux policy of course, but for those domains that
are allowed to switch then the PAM-based authentication is another control), as even evesdropping on
my password (or extracting it from memory) won't suffice to perform a successful authentication.

If you want to use a different two-factor authentication, check out the use of the [Google
authenticator][4], another nice article on the Gentoo wiki. It is also possible to use Yubico keys
for remote authentication, but that uses the OTP (One Time Password) functionality which isn't active
on the Yubico keys that I own.

[4]: https://wiki.gentoo.org/wiki/Google_Authenticator

