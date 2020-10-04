Title: Decoding the hex-coded path information in AVC denials
Date: 2014-03-30 16:37
Category: SELinux
Tags: avc, decode, path, selinux
Slug: decoding-the-hex-coded-path-information-in-avc-denials

When investigating AVC denials, some denials show a path that isn't
human readable, like so:

    type=AVC msg=audit(1396189189.734:1913): avc:  denied  { execute } for  pid=17955 comm="emerge" path=2F7661722F666669737A69596157202864656C6574656429 dev="dm-3" ino=1838 scontext=staff_u:sysadm_r:portage_t tcontext=staff_u:object_r:var_t tclass=file

To know what this file is (or actually was, because such encoded paths
mean that the file ~~wasn't accessible anymore at the time that the
denial was shown~~ contains a space), you need to hex-decode the value.
For instance, with python:

    ~$ python -c "import base64; print(base64.b16decode(\"2F7661722F666669737A69596157202864656C6574656429\"));";
    b'/var/ffisziYaW (deleted)'

In the above example, `/var/ffisziYaW` was the path of the file (note
that, as it starts with ffi, it is caused by libffi which I've blogged
about before). The reason that the file was deleted at the time the
denial was generated is because what libffi does is create a file, get
the file descriptor and unlink the file (so it is deleted and only the
(open) file handle allows for accessing it) before it wants to execute
it. As a result, the execution (which is denied) triggers a denial for
the file whose path is no longer valid (as it is now appended with
"` (deleted)`").

*Edit 1:* Thanks to IooNag who pointed me to the truth that it is due to
a space in the file name, not because it was deleted. Having the file
deleted makes the patch be appended with "` (deleted)`" which contains a
space.
