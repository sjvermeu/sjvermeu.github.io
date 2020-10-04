Title: The weird "audit_access" permission
Date: 2013-05-19 03:50
Category: SELinux
Tags: access, audit, audit_access, selinux
Slug: the-weird-audit_access-permission

While writing up the posts on capabilities, one thing I had in my mind
was to give some additional information on frequently occurring denials,
such as the *dac\_override* and *dac\_read\_search* capabilities, and
when they are triggered. For the DAC-related capabilities, policy
developers often notice that these capabilities are triggered without a
real need for them. So in the majority of cases, the policy developer
wants to disable auditing of this:

    dontaudit <somedomain> self:capability { dac_read_search dac_override };

When applications wants to search through directories not owned by the
user as which the application runs, *both* capabilities will be checked
- first the *dac\_read\_search* one and, if that is denied (it will be
audited though) then *dac\_override* is checked. If that one is denied
as well, it too will be audited. That is why many developers
automatically *dontaudit* both capability calls if the application
itself doesn't really need the permission.

Let's say you allow this because the application needs it. But then
another issue comes up when the application checks file attributes or
access permissions (which is a second occurring denial that developers
come across with). Such applications use *access()* or *faccessat()* to
get information about files, but other than that don't do anything with
the files. When this occurs and the domain does not have read, write or
execute permissions on the target, then the denial is shown even when
the application doesn't really read, write or execute the file.

    #include <stdio.h>
    #include <unistd.h>

    int main(int argc, char ** argv) {
      printf("%s: Exists (%d), Readable (%d), Writeable (%d), Executable (%d)\n", argv[1],
        access(argv[1], F_OK), access(argv[1], R_OK),
        access(argv[1], W_OK), access(argv[1], X_OK));
    }

    $ check /var/lib/logrotate.status
    /var/lib/logrotate.status: Exists (0), Readable (-1), Writeable (-1), Executable (-1)

    $ tail -1 /var/log/audit.log
    ...
    type=AVC msg=audit(1367400559.273:5224): avc:  denied  { read } for  pid=12270 comm="test" name="logrotate.status" dev="dm-3" ino=2849 scontext=staff_u:staff_r:staff_t tcontext=system_u:object_r:logrotate_var_lib_t tclass=file

This gives the impression that the application is doing nasty stuff,
even when it is merely checking permissions. One way would be to
dontaudit read as well, but if the application does the check against
several files of various types, that might mean you need to include
dontaudit statements for various domains. That by itself isn't wrong,
but perhaps you do not want to audit such checks but do want to audit
real read attempts. This is what the *audit\_access* permission is for.

The [audit\_access](http://marc.info/?l=selinux&m=125349740623497&w=2)
[permission](http://marc.info/?l=selinux&m=127239846604513) is meant to
be used only for *dontaudit* statements: it has no effect on the
security of the system itself, so using it in *allow* statements has no
effect. The purpose of the permission is to allow policy developers to
not audit access checks without really dontauditing other, possibly
malicious, attempts. In other words, checking the access can be
dontaudited while actually attempting to use the access (reading,
writing or executing the file) will still result in the proper denial.
