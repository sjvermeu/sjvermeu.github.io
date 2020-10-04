Title: Using stunnel for mutual authentication
Date: 2012-12-08 14:24
Category: Security
Slug: using-stunnel-for-mutual-authentication

Sometimes services do not support SSL/TLS, or if they do, they do not
support using mutual authentication (i.e. requesting that the client
also provides a certificate which is trusted by the service). If that is
a requirement in your architecture, you can use **stunnel** to provide
this additional SSL/TLS layer.

As an example, I have a mail server running on localhost, and I want to
provide SSMTP services with mutual authentication on top of this
service, using stunnel. First of all, I provide two certificates and
private keys that are both signed by the same CA, and keep the CA
certificate close as well:

-   client.key is the private key for the client
-   client.pem is the certificate for the client (which contains the
    public key and CA signature)
-   server.key and server.pem are the same but for the server
-   root-genfic.crt is the certificate of the signing CA

First of all, we setup the stunnel, listening on 1465 (as 465 requires
the stunnel service to run as root, which I'd rather not) and fowarding
towards 127.0.0.1:25:

    cert = /etc/ssl/services/stunnel/server.pem
    key = /etc/ssl/services/stunnel/server.key
    setuid = stunnel
    setgid = stunnel
    pid = /var/run/stunnel/stunnel.pid
    socket = l:TCP_NODELAY=1
    socket = r:TCP_NODELAY=1
    verify = 2 # This enables the mutual authentication
    CAfile = /etc/ssl/certs/root-genfic.crt

    [smtp]
    accept = 1465
    connect = 127.0.0.1:25

To test out mutual authentication this way, I used the following
command-line snippet. The delays between the lines are because the mail
client is supposed to wait for the mail server to give its reply and if
not, the data gets lost. I'm sure this can be made easier (with netcat I
could just use "-i 1" to print a line with a one-second delay), but it
works ;-)

    ~$  (sleep 1; echo "EHLO localdomain"; sleep 1; echo "MAIL FROM:remote@test.localdomain";   
   sleep 1; echo "RCPT TO:user@localhost"; sleep 1; echo "DATA"; sleep 1; cat TEMPFILE) |   
   openssl s_client -connect 192.168.100.102:1465 -crlf -ign_eof -ssl3 -key client.key -cert client.pem

The TEMPFILE file contains the email content (you know, Subject, From,
To, other headers, data, ...).

If the provided certificate isn't trusted, then you'll find the
following in the log file (on Gentoo, thats /var/log/daemon.log by
default but you can setup logging in stunnel as well):

    Dec  8 13:17:32 testsys stunnel: LOG7[20237:2766895953664]: Starting certificate verification: depth=0, /C=US/ST=California/L=Santa Barbara/O=SSL Server/OU=For Testing Purposes Only/CN=localhost/emailAddress=root@localhost
    Dec  8 13:17:32 testsys stunnel: LOG4[20237:2766895953664]: CERT: Verification error: unable to get local issuer certificate
    Dec  8 13:17:32 testsys stunnel: LOG4[20237:2766895953664]: Certificate check failed: depth=0, /C=US/ST=California/L=Santa Barbara/O=SSL Server/OU=For Testing Purposes Only/CN=localhost/emailAddress=root@localhost
    Dec  8 13:17:32 testsys stunnel: LOG7[20237:2766895953664]: SSL alert (write): fatal: bad certificate
    Dec  8 13:17:32 testsys stunnel: LOG3[20237:2766895953664]: SSL_accept: 140890B2: error:140890B2:SSL routines:SSL3_GET_CLIENT_CERTIFICATE:no certificate returned

When a trusted certificate is shown, the connection goes through.

Finally, if you not only want to validate if the certificate is trusted,
but also only want to accept a given number of certificates, you can set
the stunnel variable *verify* to 3. If you set it to 4, it will not
check the CA and only allow a connection to go through if the presented
certificate is one in the stunnel trusted certificates.
