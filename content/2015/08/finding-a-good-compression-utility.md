Title: Finding a good compression utility
Date: 2015-08-13 19:15
Category: Gentoo
Tags: gentoo, compression
Slug: finding-a-good-compression-utility

I recently came across a [wiki page](http://catchchallenger.first-world.info//wiki/Quick_Benchmark:_Gzip_vs_Bzip2_vs_LZMA_vs_XZ_vs_LZ4_vs_LZO)
written by [Herman Brule](http://catchchallenger.first-world.info/wiki/User:Alpha_one_x86)
which gives a quick benchmark on a couple of compression methods / algorithms.
It gave me the idea of writing a quick script that tests out a wide number of
compression utilities available in Gentoo (usually through the `app-arch`
category), with also a number of options (in case multiple options are
possible).

<!-- PELICAN_END_SUMMARY -->

The currently supported packages are:

```
app-arch/bloscpack      app-arch/bzip2          app-arch/freeze
app-arch/gzip           app-arch/lha            app-arch/lrzip
app-arch/lz4            app-arch/lzip           app-arch/lzma
app-arch/lzop           app-arch/mscompress     app-arch/p7zip
app-arch/pigz           app-arch/pixz           app-arch/plzip
app-arch/pxz            app-arch/rar            app-arch/rzip
app-arch/xar            app-arch/xz-utils       app-arch/zopfli
app-arch/zpaq

```

The script should keep the best compression information: duration, compression
ratio, compression command, as well as the compressed file itself.

**Finding the "best" compression**

It is not my intention to find the most optimal compression, as that would
require heuristic optimizations (which has triggered my interest in seeking
such software, or writing it myself) while trying out various optimization
parameters.

No, what I want is to find the "best" compression for a given file, with "best"
being either

- most reduced size (which I call _compression delta_ in my script)
- best reduction obtained per time unit (which I call the _efficiency_)

For me personally, I think I would use it for the various raw image files that
I have through the photography hobby. Those image files are difficult to
compress (the Nikon DS3200 I use is an entry-level camera which applies
lossy compression already for its raw files) but their total size is considerable,
and it would allow me to better use the storage I have available both on my
laptop (which is SSD-only) as well as backup server.

But next to the best compression ratio, the efficiency is also an important
metric as it shows how efficient the algorithm works in a certain time aspect.
If one compression method yields 80% reduction in 5 minutes, and another one
yields 80,5% in 45 minutes, then I might want to prefer the first one even
though that is not the best compression at all.

Although the script could be used to get the most compression (without
resolving to an optimization algorithm for the compression commands) for 
each file, this is definitely not the use case. A single run can take hours
for files that are compressed in a handful of seconds. But it can show the
best algorithms for a particular file type (for instance, do a few runs on
a couple of raw image files and see which method is most succesful).

Another use case I'm currently looking into is how much improvement I can
get when multiple files (all raw image files) are first grouped in a single
archive (`.tar`). Theoretically, this should improve the compression, but
by how much?

**How the script works**

The script does not contain much intelligence. It iterates over a wide set of
compression commands that I tested out, checks the final compressed file size,
and if it is better than a previous one it keeps this compressed file (and
its statistics).

I tried to group some of the compressions together based on the algorithm used,
but as I don't really know the details of the algorithms (it's based on manual
pages and internet sites) and some of them combine multiple algorithms, it is
more of a high-level selection than anything else.

The script can also only run the compressions of a single application (which I
use when I'm fine-tuning the parameter runs).

A run shows something like the following:

```
Original file (test.nef) size 20958430 bytes
      package name                                                 command      duration                   size compr.Δ effic.:
      ------------                                                 -------      --------                   ---- ------- -------
app-arch/bloscpack                                               blpk -n 4           0.1               20947097 0.00054 0.00416
app-arch/bloscpack                                               blpk -n 8           0.1               20947097 0.00054 0.00492
app-arch/bloscpack                                              blpk -n 16           0.1               20947097 0.00054 0.00492
    app-arch/bzip2                                                   bzip2           2.0               19285616 0.07982 0.03991
    app-arch/bzip2                                                bzip2 -1           2.0               19881886 0.05137 0.02543
    app-arch/bzip2                                                bzip2 -2           1.9               19673083 0.06133 0.03211
...
    app-arch/p7zip                                      7za -tzip -mm=PPMd           5.9               19002882 0.09331 0.01592
    app-arch/p7zip                             7za -tzip -mm=PPMd -mmem=24           5.7               19002882 0.09331 0.01640
    app-arch/p7zip                             7za -tzip -mm=PPMd -mmem=25           6.4               18871933 0.09955 0.01551
    app-arch/p7zip                             7za -tzip -mm=PPMd -mmem=26           7.7               18771632 0.10434 0.01364
    app-arch/p7zip                             7za -tzip -mm=PPMd -mmem=27           9.0               18652402 0.11003 0.01224
    app-arch/p7zip                             7za -tzip -mm=PPMd -mmem=28          10.0               18521291 0.11628 0.01161
    app-arch/p7zip                                       7za -t7z -m0=PPMd           5.7               18999088 0.09349 0.01634
    app-arch/p7zip                                7za -t7z -m0=PPMd:mem=24           5.8               18999088 0.09349 0.01617
    app-arch/p7zip                                7za -t7z -m0=PPMd:mem=25           6.5               18868478 0.09972 0.01534
    app-arch/p7zip                                7za -t7z -m0=PPMd:mem=26           7.5               18770031 0.10442 0.01387
    app-arch/p7zip                                7za -t7z -m0=PPMd:mem=27           8.6               18651294 0.11008 0.01282
    app-arch/p7zip                                7za -t7z -m0=PPMd:mem=28          10.6               18518330 0.11643 0.01100
      app-arch/rar                                                     rar           0.9               20249470 0.03383 0.03980
      app-arch/rar                                                 rar -m0           0.0               20958497 -0.00000        -0.00008
      app-arch/rar                                                 rar -m1           0.2               20243598 0.03411 0.14829
      app-arch/rar                                                 rar -m2           0.8               20252266 0.03369 0.04433
      app-arch/rar                                                 rar -m3           0.8               20249470 0.03383 0.04027
      app-arch/rar                                                 rar -m4           0.9               20248859 0.03386 0.03983
      app-arch/rar                                                 rar -m5           0.8               20248577 0.03387 0.04181
    app-arch/lrzip                                                lrzip -z          13.1               19769417 0.05673 0.00432
     app-arch/zpaq                                                    zpaq           0.2               20970029 -0.00055        -0.00252
The best compression was found with 7za -t7z -m0=PPMd:mem=28.
The compression delta obtained was 0.11643 within 10.58 seconds.
This file is now available as test.nef.7z.
```

In the above example, the test file was around 20 MByte. The best compression
compression command that the script found was:

```
~$ 7za -t7z -m0=PPMd:mem=28 a test.nef.7z test.nef
```

The resulting file (`test.nef.7z`) is 18 MByte, a reduction of 11,64%. The
compression command took almost 11 seconds to do its thing, which gave an
efficiency rating of 0,011, which is definitely not a fast one.

Some other algorithms don't do bad either with a better efficiency. For
instance:

```
   app-arch/pbzip2                                                  pbzip2           0.6               19287402 0.07973 0.13071
```

In this case, the `pbzip2` command got almost 8% reduction in less than a
second, which is considerably more efficient than the 11-seconds long `7za`
run.

**Want to try it out yourself?**

I've pushed the script to my [github](https://github.com/sjvermeu/small.coding/tree/master/sw_comprbest)
location. Do a quick review of the code first (to see that I did not include
anything malicious) and then execute it to see how it works:

```
~$ sw_comprbest -h
Usage: sw_comprbest --infile=<inputfile> [--family=<family>[,...]] [--command=<cmd>]
       sw_comprbest -i <inputfile> [-f <family>[,...]] [-c <cmd>]

Supported families: blosc bwt deflate lzma ppmd zpaq. These can be provided comma-separated.
Command is an additional filter - only the tests that use this base command are run.

The output shows
  - The package (in Gentoo) that the command belongs to
  - The command run
  - The duration (in seconds)
  - The size (in bytes) of the resulting file
  - The compression delta (percentage) showing how much is reduced (higher is better)
  - The efficiency ratio showing how much reduction (percentage) per second (higher is better)

When the command supports multithreading, we use the number of available cores on the system (as told by /proc/cpuinfo).
```

For instance, to try it out against a PDF file:

```
~$ sw_comprbest -i MEA6-Sven_Vermeulen-Research_Summary.pdf
Original file (MEA6-Sven_Vermeulen-Research_Summary.pdf) size 117763 bytes
...
The best compression was found with zopfli --deflate.
The compression delta obtained was 0.00982 within 0.19 seconds.
This file is now available as MEA6-Sven_Vermeulen-Research_Summary.pdf.deflate.
```

So in this case, the resulting file is hardly better compressed - the PDF
itself is already compressed. Let's try it against the uncompressed PDF:

```
~$ pdftk MEA6-Sven_Vermeulen-Research_Summary.pdf output test.pdf uncompress
~$ sw_comprbest -i test.pdf
Original file (test.pdf) size 144670 bytes
...
The best compression was found with lrzip -z.
The compression delta obtained was 0.27739 within 0.18 seconds.
This file is now available as test.pdf.lrz.
```

This is somewhat better:

```
~$ ls -l MEA6-Sven_Vermeulen-Research_Summary.pdf* test.pdf*
-rw-r--r--. 1 swift swift 117763 Aug  7 14:32 MEA6-Sven_Vermeulen-Research_Summary.pdf
-rw-r--r--. 1 swift swift 116606 Aug  7 14:32 MEA6-Sven_Vermeulen-Research_Summary.pdf.deflate
-rw-r--r--. 1 swift swift 144670 Aug  7 14:34 test.pdf
-rw-r--r--. 1 swift swift 104540 Aug  7 14:35 test.pdf.lrz
```

The resulting file is 11,22% reduced from the original one.

