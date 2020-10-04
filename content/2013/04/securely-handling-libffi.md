Title: Securely handling libffi
Date: 2013-04-28 03:50
Category: Security
Tags: libffi, selinux, strace
Slug: securely-handling-libffi

I've recently came across [libffi](http://sourceware.org/libffi/) again.
No, not because it was mentioned during the [Gentoo
Hardened](http://www.gentoo.org/proj/en/hardened) online meeting, but
because my `/var/tmp` wasn't mounted correctly, and **emerge** (actually
python) uses libffi. Most users won't notice this, because libffi works
behind the scenes. But when it fails, it fails bad. And SELinux actually
helped me quickly identify what the problem is.

    $ emerge --info
    segmentation fault

The abbreviation "libffi" comes from *Foreign Function Interface*, and
is a library that allows developers to dynamically call code from
another application or library. But the method how it approaches this
concerns me a bit. Let's look at some **strace** output:

    8560  open("/var/tmp/ffiZ8gKPd", O_RDWR|O_CREAT|O_EXCL, 0600) = 11
    8560  unlink("/var/tmp/ffiZ8gKPd")      = 0
    8560  ftruncate(11, 4096)               = 0
    8560  mmap(NULL, 4096, PROT_READ|PROT_EXEC, MAP_SHARED, 11, 0) = -1 EACCES (Permission denied)

Generally, what libffi does, is to create a file somewhere where it can
write files (it checks the various mounts on a system to get a list of
possible target file systems), adds the necessary data (that it wants to
execute) to it, unlinks the file from the file system (but keep the file
descriptor open, so that the file cannot (easily) be modified on the
system anymore) and then maps it to memory for executable access. *If*
executing is allowed by the system (for instance because the mount point
does not have `noexec`), then SELinux will trap it because the domain
(in our case now, `portage_t`) is trying to execute an (unlinked) file
for which it holds no execute rights on:

    type=AVC msg=audit(1366656205.201:2221): avc:  denied  { execute } for  
    pid=8560 comm="emerge" path=2F7661722F66666962713154465A202864656C6574656429 
    dev="dm-3" ino=6912 scontext=staff_u:sysadm_r:portage_t tcontext=staff_u:object_r:var_t
    tclass=file

When you notice something like this (an execute on an unnamed file),
then this is because the file descriptor points to a file already
unlinked from the system. Finding out what it was about might be hard
(but with **strace** it is easy as ... well, whatever is easy for you).

Now what happened was that, because `/var/tmp` wasn't mounted, files
created inside it got the standard type (`var_t`) which the Portage
domain isn't allowed to execute. It is allowed to execute a lot of
types, but not that one ;-) When `/var/tmp` is properly mounted, the
file gets the `portage_tmp_t` type where it does hold execute rights
for.

Now generally, I don't like having world-writeable locations without
`noexec`. For `/tmp`, `noexec` is enabled, but for `/var/tmp` I have
(well, had ;-) to allow execution from the file system, mainly because
some (many?) Gentoo package builds require it. So how about this dual
requirement, of allowing Portage to write (and execute) its own files,
and allow libffi to do its magic? Certainly, from a security point of
view, I might want to restrict this further...

Well, we need to make sure that the location where Portage works with
(the location pointed to by `$PORTAGE_TMPDIR`) is specifically made
available for Portage: have the directory only writable by the Portage
user. I keep it labeled as `tmp_t` so that the existing policies apply,
but it might work with `portage_tmp_t` immediately set as well. Perhaps
I'll try that one later. With that set, we can have this mount-point set
with exec rights (so that libffi can place its file there) in a somewhat
more secure manner than allowing exec on world-writeable locations.

So now my `/tmp` and `/var/tmp` (and `/run` and `/dev/shm` and
`/lib64/rc/init.d`) are tmpfs-mounts with the `noexec` (as well as
`nodev` and `nosuid`) bits set, with the location pointed towards by
`$PORTAGE_TMPDIR` being only really usable by the Portage user:

    $ ls -ldZ /var/portage
    drwxr-x---. 4 portage root system_u:object_r:tmp_t 4096 Apr 22 21:45 /var/portage/

And libffi? Well, allowing applications to create their own executables
and executing it is something that should be carefully governed. I'm not
aware of any existing or past vulnerabilities, but I can imagine that
opening the `ffi*` file(s) the moment they come up (to make sure you
have a file descriptor) allows you to overwrite the content after libffi
has created it but before the application actually executes it. By
limiting the locations where applications can write files to (important
step one) and the types they can execute (important step two) we can
already manage this a bit more. Using regular DAC, this is quite
difficult to achieve, but with SELinux, we can actually control this a
bit more.

Let's first see how many domains are allowed to create, write and
execute files:

    $ sesearch -c file -p write,create,execute -A | grep write | grep create   
     | grep execute | awk '{print $1}' | sort | uniq | wc -l
    32

Okay, 32 target domains. Not that bad, and certainly doable to verify
manually (hell, even in a scripted manner). You can now check which of
those domains have rights to execute generic binaries (`bin_t`),
possibly needed for command execution vulnerabilities or privilege
escalation. Or that have specific capabilities. And if you want to know
which of those domains use libffi, you can use **revdep-rebuild** to
find out which files are linked to the libffi libraries.

It goes to show that trying to keep your box secure is a never-ending
story (please, companies, allow your system administrators to do their
job by giving them the ability to continuously increase security rather
than have them ask for budget to investigate potential security
mitigation directives based on the paradigm of business case and return
on investment using pareto-analytics blaaaahhhh....), and that SELinux
can certainly be an important method to help achieve it.
