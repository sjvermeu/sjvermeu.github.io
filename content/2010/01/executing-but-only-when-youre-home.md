Title: Executing, but only when you're home
Date: 2010-01-18 23:48
Category: Free-Software
Slug: executing-but-only-when-youre-home

Sometimes you want to execute a particular command, but only when you're
at home. Examples would be running fetchmail (or fetchnews) through
cron, but you don't want this to run when you're in the train, connected
to the Internet through GPRS...

My idea here would be to create a script (say "athome.sh") which returns
0 if you're at home, and 1 otherwise. The key of the script is that the
MAC address of your (default) gateway is unique.

    #!/bin/sh

    GW=$(/sbin/ip route | awk '/default/ {print $3}');
    MGW=$(/sbin/arp -e | grep ${GW} | awk '{print $3}');

    if [ "${MGW}" = "00:11:22:33:44:55" ]
    then
      exit 0;
    else
      exit 1;
    fi

With this script, you can then run `athome.sh && fetchmail`. If you
aren't home, `athome.sh` will return 1 and the fetchmail command will
never be executed. When you are, the command returns 0 and fetchmail is
launched.
