Title: Introducing selocal for small SELinux policy enhancements
Date: 2013-04-21 03:50
Category: Gentoo
Tags: Gentoo, policy, selinux, selocal
Slug: introducing-selocal-for-small-selinux-policy-enhancements

When working with a SELinux-enabled system, administrators will
eventually need to make small updates to the existing policy. Instead of
building their own full policy (always an option, but most likely not
maintainable in the long term) one or more SELinux policy modules are
created (most distributions use a modular approach to the SELinux policy
development) which are then loaded on their target systems.

In the past, users had to create their own policy module by creating
(and maintaining) the necessary `.te` file(s), building the proper `.pp`
files and loading it in the active policy store. In Gentoo, from
`policycoreutils-2.1.13-r11` onwards, a script is provided to the users
that hopefully makes this a bit more intuitive for regular users:
**selocal**.

As the name implies, **selocal** aims to provide an interface for
handling *local* policy updates that do not need to be packaged or
distributed otherwise. It is a command-line application that you feed
single policy rules at one at a time. Each rule can be accompanied with
a single-line comment, making it obvious for the user to know why he
added the rule in the first place.

    # selocal --help
    Usage: selocal [] [] 

    Command can be one of:
      -l, --list            List the content of a SELinux module
      -a, --add             Add an entry to a SELinux module
      -d, --delete          Remove an entry from a SELinux module
      -M, --list-modules    List the modules currently known by selocal
      -u, --update-dep      Update the dependencies for the rules
      -b, --build           Build the SELinux module (.pp) file (requires privs)
      -L, --load            Load the SELinux module (.pp) file (requires privs)

    Options can be one of:
      -m, --module          Module name to use (default: selocal)
      -c, --comment        Comment (with --add)

    The option -a requires that a rule is given, like so:
      selocal -a "dbadm_role_change(staff_r)"
    The option -d requires that a line number, as shown by the --list, is given, like so:
      selocal -d 12

Let's say that you need to launch a small script you written as a
daemon, but you want this to run while you are still in the *staff\_t*
domain (it is a user-sided daemon you use personally). As regular
*staff\_t* isn't allowed to have processes bind on generic ports/nodes,
you need to enhance the SELinux policy a bit. With **selocal**, you can
do so as follows:

    # selocal --add "corenet_tcp_bind_generic_node(staff_t)" --comment "Launch local webserv.py daemon"
    # selocal --add "corenet_tcp_bind_generic_port(staff_t)" --comment "Launch local webserv.my daemon"
    # selocal --build --load
    (some output on building the policy module)

When finished, the local policy is enhanced with the two mentioned
rules. You can query which rules are currently stored in the policy:

    # selocal --list
    12: corenet_tcp_bind_generic_node(staff_t) # Launch local webserv.py daemon
    13: corenet_tcp_bind_generic_port(staff_t) # Launch local webserv.py daemon

If you need to delete a rule, just pass the line number:

    # selocal --delete 13

Having this tool around also makes it easier to test out changes
suggested through bugreports. When I test such changes, I add in the bug
report ID as the comment so I can track which settings are still local
and which ones have been pushed to our policy repository. Underlyingly,
**selocal** creates and maintains the necessary policy file in
<path>\~/.selocal</path> and by default uses the *selocal* policy module
name.

I hope this tool helps users with their quest on using SELinux. Feedback
and comments are always appreciated! It is a small bash script and might
still have a few bugs in it, but I have been using it for a few months
so most quirks should be handled.
