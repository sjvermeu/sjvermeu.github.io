Title: cvechecker 3.8 released
Date: 2017-03-27 19:00
Category: Free Software
Tags: cvechecker
Slug: cvechecker-3.8-released

A new release is now available for the [cvechecker](https://github.com/sjvermeu/cvechecker/wiki) application.
This is a stupid yet important bugfix release: the 3.7 release saw all newly released CVEs as being already
known, so it did not take them up to the database. As a result, systems would never check for the new CVEs.

<!-- PELICAN_END_SUMMARY -->

It is recommended to remove any historical files from `/var/lib/cvechecker/cache` like so:

```
~# rm /var/lib/cvechecker/cache/nvdcve-2.0-2017.*
~# rm /var/lib/cvechecker/cache/nvdcve-2.0-modified.*
```

This will make sure that the next run of `pullcves pull` will re-download those files, and attempt to load
the resulting CVEs back in the database.

Sorry for this issue :-(

