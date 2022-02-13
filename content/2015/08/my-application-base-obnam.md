Title: My application base: Obnam
Date: 2015-08-05 22:35
Category: Free-Software
Tags: mab, backup, obnam
Slug: my-application-base-obnam

It is often said, yet too often forgotten: taking backups (and verifying that 
they work). Taking backups is not purely for companies and organizations.
Individuals should also take backups to ensure that, in case of errors or
calamities, the all important files are readily recoverable.

For backing up files and directories, I personally use [obnam](http://obnam.org/),
after playing around with [Bacula](http://www.bacula.org/) and
[attic](https://attic-backup.org/). Bacula is more meant for large
distributed environments (although I also tend to use obnam for my server
infrastructure) and was too complex for my taste. The choice between obnam and
attic is even more personally-oriented.

<!-- PELICAN_END_SUMMARY -->

I found attic to be faster, but with a small supporting community. Obnam was
slower, but seems to have a more active community which I find important for 
infrastructure that is meant to live quite long (you don't want to switch 
backup solutions every year). I also found it pretty easy to work with, and
to restore files back, and Gentoo provides the [app-backup/obnam](https://packages.gentoo.org/package/app-backup/obnam)
package.

I think both are decent solutions, so I had to make one choice and ended up
with obnam. So, how does it work?

**Configuring what to backup**

The basic configuration file for obnam is `/etc/obnam.conf`. Inside this file,
I tell which directories need to be backed up, as well as which subdirectories
or files (through expressions) can be left alone. For instance, I don't want
obnam to backup ISO files as those have been downloaded anyway.

```ini
[config]
repository = /srv/backup
root = /root, /etc, /var/lib/portage, /srv/virt/gentoo, /home
exclude = \.img$, \.iso$, /home/[^/]*/Development/Centralized/.*
exclude-caches = yes

keep = 8h,14d,10w,12m,10y
```

The `root` parameter tells obnam which directories (and subdirectories) to
back up. With `exclude` a particular set of files or directories can be
excluded, for instance because these contain downloaded resources (and as such
do not need to be inside the backup archives).

Obnam also supports the [CACHEDIR.TAG](http://www.brynosaurus.com/cachedir/spec.html)
specification, which I use for the various cache directories. With the use of 
these cache tag files I do not need to update the `obnam.conf` file with every
new cache directory (or software build directory).

The last parameter in the configuration that I want to focus on is the `keep`
parameter. Every time obnam takes a backup, it creates what it calls a new
_generation_. When the backup storage becomes too big, administrators can run
`obnam forget` to drop generations. The `keep` parameter informs obnam which
generations can be removed and which ones can be kept.

In my case, I want to keep one backup per hour for the last 8 hours (I normally
take one backup per day, but during some development sprees or photo
manipulations I back up multiple times), one per day for the last two weeks, 
one per week for the last 10 weeks, one per month for the last 12 months and
one per year for the last 10 years.

Obnam will clean up only when `obnam forget` is executed. As storage is cheap,
and the performance of obnam is sufficient for me, I do not need to call this
very often.

**Backing up and restoring files**

My backup strategy is to backup to an external disk, and then synchronize this
disk with a personal backup server somewhere else. This backup server runs no
other software beyond OpenSSH (to allow secure transfer of the backups) and both
the backup server disks and the external disk is [LUKS](https://wiki.gentoo.org/wiki/Dm-crypt)
encrypted. Considering that I don't have government secrets I opted not to encrypt
the backup files themselves, but Obnam does support that (through GnuPG).

All backup enabled systems use cron jobs which execute `obnam backup` to take
the backup, and use rsync to synchronize the finished backup with the backup
server. If I need to restore a file, I use `obnam ls` to see which file(s) I
need to restore (add in a `--generation=` to list the files of a different
backup generation than the last one).

Then, the command to restore is:

    ~# obnam restore --to=/var/restore /home/swift/Images/Processing/*.NCF

Or I can restore immediately to the directory again:

    ~# obnam restore --to=/home/swift/Images/Processing /home/swift/Images/Processing/*.NCF

To support multiple clients, obnam by default identifies each client through
the hostname. It is possible to use different names, but hostnames tend to be
a common best practice which I don't deviate from either. Obnam is able to share
blocks between clients (it is not mandatory, but supported nonetheless).

