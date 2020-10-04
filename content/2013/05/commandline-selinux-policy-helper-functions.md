Title: Commandline SELinux policy helper functions
Date: 2013-05-18 03:50
Category: SELinux
Tags: bash, definition, functions, interface, policy, selinux, support
Slug: commandline-selinux-policy-helper-functions

To work on SELinux policies, I use a couple of functions that I can call
on the shell (command line): **seshowif**, **sefindif**, **seshowdef**
and **sefinddef**. The idea behind the methods is that I want to search
(*find*) for an interface (*if*) or definition (*def*) that contains a
particular method or call. Or, if I know what the interface or
definition is, I want to see it (*show*).

For instance, to find the name of the interface that allows us to define
file transitions from the `postfix_etc_t` label:

    $ sefindif filetrans.*postfix_etc
    contrib/postfix.if: interface(`postfix_config_filetrans',`
    contrib/postfix.if:     filetrans_pattern($1, postfix_etc_t, $2, $3, $4)

Or to show the content of the *corenet\_tcp\_bind\_http\_port*
interface:

    $ seshowif corenet_tcp_bind_http_port
    interface(`corenet_tcp_bind_http_port',`
            gen_require(`
                    type http_port_t;
            ')

            allow $1 http_port_t:tcp_socket name_bind;
            allow $1 self:capability net_bind_service;
    ')

For the definitions, this is quite similar:

    $ sefinddef socket.*create
    obj_perm_sets.spt:define(`create_socket_perms', `{ create rw_socket_perms }')
    obj_perm_sets.spt:define(`create_stream_socket_perms', `{ create_socket_perms listen accept }')
    obj_perm_sets.spt:define(`connected_socket_perms', `{ create ioctl read getattr write setattr append bind getopt setopt shutdown }')
    obj_perm_sets.spt:define(`create_netlink_socket_perms', `{ create_socket_perms nlmsg_read nlmsg_write }')
    obj_perm_sets.spt:define(`rw_netlink_socket_perms', `{ create_socket_perms nlmsg_read nlmsg_write }')
    obj_perm_sets.spt:define(`r_netlink_socket_perms', `{ create_socket_perms nlmsg_read }')
    obj_perm_sets.spt:define(`client_stream_socket_perms', `{ create ioctl read getattr write setattr append bind getopt setopt shutdown }')

    $ seshowdef manage_files_pattern
    define(`manage_files_pattern',`
            allow $1 $2:dir rw_dir_perms;
            allow $1 $3:file manage_file_perms;
    ')

I have these defined in my `~/.bashrc` (they are simple
[functions](http://dev.gentoo.org/~swift/blog/01/selinux-funcs.txt)) and
are used on a daily basis here ;-) If you want to learn a bit more on
developing SELinux policies for Gentoo, make sure you read the [Gentoo
Hardened SELinux
Development](http://www.gentoo.org/proj/en/hardened/selinux-development.xml)
guide.
