#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = u'Sven Vermeulen'
SITENAME = u'Simplicity is a form of art...'
SITEURL = 'http://192.168.1.71:8000'

PATH = 'content'

TIMEZONE = 'Europe/Brussels'

DEFAULT_LANG = u'en'

# Social widget
SOCIAL = (
  ('github', 'https://github.com/infrainsight'),
  ('twitter', 'https://twitter.com/infrainsight'),
  ('linkedin', 'https://www.linkedin.com/in/svenvermeulen')
)

DEFAULT_PAGINATION = 10

# Formatting
ARTICLE_URL = u'{date:%Y}/{date:%m}/{slug}/'
ARTICLE_SAVE_AS = u'{date:%Y}/{date:%m}/{slug}/index.html'

CATEGORY_URL = u'category/{slug}.html'
CATEGORY_SAVE_AS = u'category/{slug}.html'

TAG_URL = u'tag/{slug}/'
TAG_SAVE_AS = u'tag/{slug}/index.html'

# Generate yearly archive

YEAR_ARCHIVE_SAVE_AS = u'posts/{date:%Y}/index.html'

# Show most recent posts first

NEWEST_FIRST_ARCHIVES = True

# Specify theme

THEME = "themes/simplify-theme"
DISPLAY_CATEGORIES_ON_MENU = False
SHOW_ARTICLE_CATEGORY = True
DISPLAY_ARTICLE_INFO_ON_INDEX = True
SHOW_ARTICLE_AUTHOR = True
AUTHOR_URL = 'pages/about.html'

# TODO Search currently does not seem to work well, verify later again
# TODO Remove when publishing
# SEARCH_URL = "file://docs/search.html"

# Plugins

PLUGIN_PATHS = ['plugins']
PLUGINS = ['sitemap', 'extract_toc', 'summary', 'tipue_search'] 
# MD_EXTENSIONS = ['codehilite(css_class=highlight, guess_lang=False)', 'extra', 'headerid', 'toc']
MARKDOWN = {
    'extension_configs': {
        'markdown.extensions.codehilite': {
            'css_class': 'highlight',
            'guess_lang': 'False'
        },
        'markdown.extensions.extra': {},
        'markdown.extensions.meta': {}
    },
    'output_format': 'html5',
}

DIRECT_TEMPLATES = (('index', 'tags', 'categories', 'archives', 'search')) 

# Disabling due to security concerns (for visitors)
#DISQUS_SITENAME = "simplicityisaformofart"

SITEMAP = {
  'format': 'xml',
  'priorities': {
    'articles': 0.5,
    'indexes': 0.5,
    'pages': 0.5
  },
  'changefreqs': {
    'articles': 'monthly',
    'indexes': 'daily',
    'pages': 'monthly'
  }
}

STATIC_PATHS = ['images','static','CNAME']
