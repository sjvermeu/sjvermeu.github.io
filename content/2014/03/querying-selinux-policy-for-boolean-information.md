Title: Querying SELinux policy for boolean information
Date: 2014-03-28 23:38
Category: SELinux
Tags: boolean, query, selinux, sesearch
Slug: querying-selinux-policy-for-boolean-information

Within an SELinux policy, certain access vectors (permissions) can be
conditionally granted based on the value of a *SELinux boolean*.

To find the list of SELinux booleans that are available on your system,
you can use the **getsebool -a** method, or **semanage boolean -l**. The
latter also displays the description of the boolean:

    ~# semanage boolean -l | grep user_ping
    user_ping                      (on   ,   on)  Control users use of ping and traceroute

You can easily query the SELinux policy to see what this boolean
triggers:

    ~# sesearch -b user_ping -A -C
    Found 22 semantic av rules:
    ET allow ping_t staff_t : process sigchld ; [ user_ping ]
    ET allow ping_t staff_t : fd use ; [ user_ping ]
    ET allow ping_t staff_t : fifo_file { ioctl read write getattr lock append open } ; [ user_ping ]
    ET allow ping_t user_t : process sigchld ; [ user_ping ]
    ET allow ping_t user_t : fd use ; [ user_ping ]
    ...

However, often you want to know if a particular access is allowed and,
if it is conditionally allowed, which boolean enables it. In the case of
user ping, we want to know if (and when) a user domain (`user_t`) is
allowed to transition to the ping domain (`ping_t`):

    ~# sesearch -s user_t -t ping_t -c process -p transition -ACTS
    Found 1 semantic av rules:
    ET allow user_t ping_t : process transition ; [ user_ping ]

So there you go - it is allowed if the `user_ping` SELinux boolean is
enabled.
