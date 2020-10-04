Title: Local policy management script
Date: 2012-11-11 13:37
Category: SELinux
Slug: local-policy-management-script

I've written a small script that I call **selocal** which manages
locally needed SELinux rules. It allows me to add or remove SELinux
rules from the command line and have them loaded up without needing to
edit a .te file and building the .pp file manually. If you are
interested, you can download it from my [github
location](https://raw.github.com/sjvermeu/small.coding/master/se_scripts/selocal).

Its usage is as follows:

-   You can *add* a rule to the policy with **selocal -a "rule"**
-   You can *list* the current rules with **selocal -l**
-   You can *remove* entries by referring to their number (in the
    listing output), like **semodule -d 19**.
-   You can ask it to build (**-b**) and load (**-L**) the policy when
    you think it is appropriate

It even supports multiple modules in case you don't want to have all
local rules in a single module set.

So when I wanted to give a presentation on Tor, I had to allow the
torbrowser to connect to an unreserved port. The torbrowser runs in the
mozilla domain, so all I did was:

    ~# selocal -a "corenet_tcp_connect_all_unreserved_ports(mozilla_t)" -b -L

At the end of the presentation, I removed the line from the policy:

    ~# selocal -l | grep mozilla_t
    19. corenet_tcp_connect_all_unreserved_ports(mozilla_t)
    ~# selocal -d 19 -b -L

I can also add in comments in case I would forget why I added it in the
first place:

    ~# selocal -a "allow mplayer_t self:udp_socket create_socket_perms;"   
     -c "MPlayer plays HTTP resources" -b -L

This then also comes up when listing the current local policy rules:

    ~# selocal -l
    ...
    40: allow mplayer_t self:udp_socket create_socket_perms; # MPlayer plays HTTP resources
