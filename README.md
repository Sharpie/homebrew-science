[![For science.](http://i.imgur.com/Bswp1.png) ](http://xkcd.com/585)

Overview
========

Recent versions of Homebrew have the ability to install brews from both
URLs and local file paths.

This repository contains UNOFFICIAL brews that have not been accepted into
the master branch. Most formulae in this repository focus on software that is
very specific to certain scientific disciplines and would probably be seen as
"clutter" or "noise" by most Homebrew users.

Additionally, some of the brews provided here install software for which the
source code is not freely available for download. Users of these brews will
have to obtain the source code directly from the respective authors.

These brews can be installed via the raw GitHub URLs, or by cloning this
repository locally and installing off the local disk.


Contents
========

gis
---
Brews for geospatial tools and libraries.

non-free
--------
These brews provide non-free software. In most cases, the user will be
required to obtain the source code and place it in Homebrew's cache
directory before installing. The cache directory is usually located at:

    ~/Library/Caches/Homebrew

quartz
------
Brews that make use of a native Quartz-based GTK+ library rather than the
one in mxcl/master which targets X11. Most everything here is highly
experimental and builds keg-only.

scientific
----------
Brews for scientific tools or libraries.

unstable
--------
Brews that are either works in progress or not thoroughly tested. Here
there be dragons!

