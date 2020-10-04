Title: SELinux quicky
Date: 2010-09-14 23:44
Category: SELinux
Slug: selinux-quicky

I've been using SELinux for a few days now (in permissive mode, just to
get to know things) and have learned a few interesting commands (or
other nice-to-know's) for using SELinux. Since I'm going to forget those
the moment all is running well, I'll "document" them here ;-) I'm not
going to talk about the **-Z** switches in **ps** or **ls**, that has
been documented sufficiently on the Internet already.

With **sesearch** you can query through the loaded policy. For instance,
you want to know why you can execute **sudo** as a user (and not just
due to the DAC permissions):

    ~$ sesearch -s user_t -t sudo_exec_t -p execute -c file -A

Of course, this is only one of the three requirements for a transition
from `user_t` to `user_sudo_t`, for that you still need process
transition and entrypoint:

    ~$ sesearch -s user_t -t user_sudo_t -p transition -A 
    ~$ sesearch -s user_sudo_t -t sudo_exec_t -p entrypoint -A

Now, sometimes you find a rule that you didn't expect:

    ~$ sesearch -s user_t -t dmesg_exec_t -p execute -A
    Found 1 semantic av rules:
      allow user_t application_exec_type : file { ioctl read getattr lock execute execute_no_trans open } ; 

This is because `dmesg_exec_t` has the `application_exec_type` attribute
set. You can see the list of types that have an attribute set (or vice
versa) with **seinfo**:

    (Show list of types that have the application_exec_type attribute)
    ~$ seinfo -aapplication_exec_type -x
    (Show list of attributes given to the dmesg_exec_t type)
    ~$ seinfo -tdmesg_exec_t -x

Now, during my browsing through the SELinux activities on my system, I
noticed that I could run `/usr/sbin/dnsmasq` as root, without generating
an error in the avc log. Yet **sesearch** didn't give any results. I've
almost killed a few kittens by searching for possibilities (perhaps
types with `exec_type` automatically have `application_exec_type` - not,
or perhaps the domain transitions to another domain first without me
knowing - not, I would see that the process runs as a different domain
then, which wasn't the case). Luckily, dgrift on `#selinux` gave me the
hint of checking the *dontaudit* rules as well:

    ~$ sesearch --dontaudit -s sysadm_t -t dnsmasq_exec_t
    ...
       dontaudit sysadm_t exec_type : file { execute execute_no_trans } ;

So there we had it - it was being denied, just not logged. And because I
ran in permissive mode, it gets executed anyhow. I disabled the
dontaudit rules and got the avc denial I was expecting:

    (Disable dontaudit rules)
    ~$ semodule -DB
    (Reenable dontaudit rules)
    ~$ semodule -B
