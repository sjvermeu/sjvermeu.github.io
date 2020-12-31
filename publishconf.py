#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

# This file is only used if you use `make publish` or
# explicitly specify it as your config file.

import os
import sys
sys.path.append(os.curdir)
from pelicanconf import *

RELATIVE_URLS = False

SITEURL = 'https://blog.siphos.be'

# My blog seems to be aggregated as follows:
# /feed/                    Complete RSS feed
# /category/gentoo/feed/    Gentoo category feed (planet.gentoo.org)
# /feed/atom/               Complete ATOM feed

CATEGORY_FEED_ATOM = 'category/{slug}/feed/atom.xml'
CATEGORY_FEED_RSS = 'category/{slug}/feed/rss.xml'
FEED_ATOM = 'feed/atom.xml'
FEED_ALL_ATOM = 'feed/all.atom.xml'
FEED_RSS = 'feed/rss.xml'
FEED_ALL_RSS = 'feed/all.rss.xml'
TAG_FEED_ATOM = 'tag/{slug}/feed/atom.xml'
TAG_FEED_RSS = 'tag/{slug}/feed/rss.xml'
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Disable tag cloud as it is ugly for now
TAG_CLOUD_MAX_ITEMS = 0

# Set additional links
LINKS = (('Gentoo Linux', 'http://www.gentoo.org'),)

DELETE_OUTPUT_DIRECTORY = False
