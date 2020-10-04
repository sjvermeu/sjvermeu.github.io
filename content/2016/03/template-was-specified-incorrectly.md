Title: Template was specified incorrectly
Date: 2016-03-27 13:32
Category: Free Software
Tags: salt
Slug: template-was-specified-incorrectly

After reorganizing my salt configuration, I received the following error:

```
[ERROR   ] Template was specified incorrectly: False
```

Enabling some debugging on the command gave me a slight pointer why this occurred:

```
[DEBUG   ] Could not find file from saltenv 'testing', u'salt://top.sls'
[DEBUG   ] No contents loaded for env: testing
[DEBUG   ] compile template: False
[ERROR   ] Template was specified incorrectly: False
```

I was using a single top file as recommended by Salt, but apparently it was still
looking for top files in the other environments.

Yet, if I split the top files across the environments, I got the following warning:

```
[WARNING ] Top file merge strategy set to 'merge' and multiple top files found. Top file merging order is undefined; for better results use 'same' option
```

So what's all this about?

<!-- PELICAN_END_SUMMARY -->

**When using a single top file is preferred**

If you want to stick with a single top file, then the first error is (or at least, in my case)
caused by my environments not having a fall-back definition.

My `/etc/salt/master` configuration file had the following `file_roots` setting:

```
file_roots:
  base:
    - /srv/salt/base
  testing:
    - /srv/salt/testing
```

The problem is that Salt expects ''a'' top file through the environment. What I had to do was to
set the fallback directory to the base directory again, like so:

```
file_roots:
  base:
    - /srv/salt/base
  testing:
    - /srv/salt/testing
    - /srv/salt/base
```

With this set, the error disappeared and both salt and myself were happy again.

**When multiple top files are preferred**

If you really want to use multiple top files (which is also a use case in my configuration),
then first we need to make sure that the top files of all environments correctly isolate the
minion matches. If two environments would match the same minion, then this approach becomes
more troublesome.

On the one hand, we can just let saltstack merge the top files (default behavior) but the order
of the merging is undefined (and no, you can't set it using `env_order`) which might result in 
salt states being executed in an unexpected order. If the definitions are done to such an extend
that this is not a problem, then you can just ignore the warning. See also
[bug 29104](https://github.com/saltstack/salt/issues/29104) about the warning itself.

But better would be to have the top files of the environment(s) isolated so that each environment
top file completely manages the entire environment. When that is the case, then we tell salt that
only the top file of the affected environment should be used. This is done using the following
setting in `/etc/salt/master`:

```
top_file_merging_strategy: same
```

If this is used, then the `env_order` setting is used to define in which order the environments
are processed. 

Oh and if you're using `salt-ssh`, then be sure to set the environment of the minion in the roster
file, as there is no running minion on the target system that informs salt about the environment 
to use otherwise:

```
# In /etc/salt/roster
testserver:
  host: testserver.example.com
  minion_opts:
    environment: testing
```

