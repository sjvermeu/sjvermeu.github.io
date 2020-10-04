Title: SELinux and extended permissions
Date: 2017-11-20 17:00
Category: SELinux
Tags: selinux,ioctl
Slug: selinux-and-extended-permissions

One of the features present in the [August release][1] of the SELinux user space is its support for ioctl xperm rules in modular policies. In the past, this was only possible in monolithic ones (and CIL). Through this, allow rules can be extended to not only cover source (domain) and target (resource) identifiers, but also a specific number on which it applies. And ioctl's are the first (and currently only) permission on which this is implemented.
 
[1]: https://github.com/SELinuxProject/selinux/wiki/Releases
 
Note that ioctl-level permission controls isn't a new feature by itself, but the fact that it can be used in modular policies is.
 
<!-- PELICAN_END_SUMMARY -->

**What is ioctl?**
 
Many interactions on a Linux system are done through system calls. From a security perspective, most system calls can be properly categorized based on who is executing the call and what the target of the call is. For instance, the unlink() system call has the following prototype:
 
```
int unlink(const char *pathname);
```
 
Considering that a process (source) is executing unlink (system call) against a target (path) is sufficient for most security implementations. Either the source has the permission to unlink that file or directory, or it hasn't. SELinux maps this to the unlink permission within the file or directory classes:

```
allow <domain> <resource> : { file dir }  unlink;
```

Now, `ioctl()` is somewhat different. It is a system call that allows device-specific operations which cannot be expressed by regular system calls. Devices can have multiple functions/capabilities, and with `ioctl()` these capabilities can be interrogated or updated. It has the following interface:

```
int ioctl(int fd, unsigned long request, ...);
```
 
The file descriptor is the target device on which an operation is launched. The second argument is the request, which is an integer whose value identifiers what kind of operation the `ioctl()` call is trying to execute. So unlike regular system calls, where the operation itself is the system call, `ioctl()` actually has a parameter that identifies this.
 
A list of possible parameter values on a socket for instance is available in the Linux kernel source code, under [include/uapi/linnux/sockios.h][2].
 
[2]: https://elixir.free-electrons.com/linux/latest/source/include/uapi/linux/sockios.h
 
**SELinux allowxperm**
 
For SELinux, having the purpose of the call as part of a parameter means that a regular mapping isn't sufficient. Allowing `ioctl()` commands for a domain against a resource is expressed as follows:

```
allow <domain> <resource> : <class> ioctl;
```

This of course does not allow policy developers to differentiate between harmless or informative calls (like SIOCGIFHWADDR to obtain the hardware address associated with a network device) and impactful calls (like SIOCADDRT to add a routing table entry).
 
To allow for a fine-grained policy approach, the SELinux developers introduced an extended allow permission, which is capable of differentiating based on an integer value.
 
For instance, to allow a domain to get a hardware address (SIOCGIFHWADDR, which is 0x8927) from a TCP socket:

```
allowxperm <domain> <resource> : tcp_socket ioctl 0x8927;
```

This additional parameter can also be ranged:

```
allowxperm <domain> <resource> : <class> ioctl 0x8910-0x8927;
```

And of course, it can also be used to complement (i.e. allow all ioctl parameters except a certain value):

```
allowxperm <domain> <resource> : <class> ioctl ~0x8927;
```

**Small or negligible performance hit**
 
According to a [presentation given by Jeff Vander Stoep][3] on the Linux Security Summit in 2015, the performance impact of this addition in SELinux is well under control, which helped in the introduction of this capability in the Android SELinux implementation.
 
[3]: http://kernsec.org/files/lss2015/vanderstoep.pdf
 
As a result, interested readers can find examples of allowxperm invocations in the SELinux policy in Android, such as in the [app.te][4] file:
 
[4]: https://android.googlesource.com/platform/system/sepolicy/+/master/private/app.te

```
# only allow unprivileged socket ioctl commands
allowxperm { appdomain -bluetooth } self:{ rawip_socket tcp_socket udp_socket } ioctl { unpriv_sock_ioctls unpriv_tty_ioctls };
```

And with that, we again show how fine-grained the SELinux access controls can be.

