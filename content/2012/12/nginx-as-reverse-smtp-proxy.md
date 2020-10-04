Title: nginx as reverse SMTP proxy
Date: 2012-12-06 00:03
Category: Free Software
Slug: nginx-as-reverse-smtp-proxy

I've noticed that not that many resources are online telling you how you
can use nginx as a reverse SMTP proxy. Using a reverse SMTP proxy makes
sense even if you have just one mail server back-end, either because you
can easily switch towards another one, or because you want to put
additional checks before handing off the mail to the back-end.

In the below example, a back-end mail server is running on localhost (in
my case it's a Postfix back-end, but that doesn't matter). Mails
received by Nginx will be forwarded to this server.

    user nginx nginx;
    worker_processes 1;

    error_log /var/log/nginx/error_log debug;

    events {
            worker_connections 1024;
            use epoll;
    }
    http {

            log_format main
                    '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $bytes_sent '
                    '"$http_referer" "$http_user_agent" '
                    '"$gzip_ratio"';


            server {
                    listen 127.0.0.1:8008;
                    server_name localhost;
                    access_log /var/log/nginx/localhost.access_log main;
                    error_log /var/log/nginx/localhost.error_log info;

                    root /var/www/localhost/htdocs;

                    location ~ .php$ {
                            add_header Auth-Server 127.0.0.1;
                            add_header Auth-Port 25;
                            return 200;
                    }
            }
    }

    mail {
            server_name localhost;

            auth_http localhost:8008/auth-smtppass.php;

            server {
                    listen 192.168.100.102:25;
                    protocol smtp;
                    timeout 5s;
                    proxy on;
                    xclient off;
                    smtp_auth none;
            }
    }

If you first look at the *mail* setting, you notice that I include an
*auth\_http* directive. This is needed by Nginx as it will consult this
back-end service on what to do with the mail (the moment that it
receives the recipient information). The URL I use is arbitrarily chosen
here, as I don't really run a PHP service in the background (yet).

In the *http* section, I create the same resource that the mails'
auth\_http wants to connect to. I then declare the two return headers
that Nginx needs (Auth-Server and Auth-Port) with the back-end
information (127.0.0.1:25). If I ever need to do load balancing or other
tricks, I'll write up a simple PHP script and serve it from PHP-FPM or
so.

Next on the list is to enable SSL (not difficult) with client
authentication (which isn't supported by Nginx for the mail module (yet)
sadly, so I'll need to look at a different approach for that).

BTW, this is all on a simple Gentoo Hardened with SELinux enabled. The
following booleans were set to true: *nginx\_enable\_http\_server*,
*nginx\_enable\_smtp\_server* and *nginx\_can\_network\_connect\_http*.

This page has been translated into
[Spanish](http://www.webhostinghub.com/support/es/misc/nginx-como-poder)
language by Maria Ramos from
[Webhostinghub.com/support/edu](http://www.webhostinghub.com/support/edu).
