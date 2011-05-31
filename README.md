# Overview

Recent versions of Homebrew have the ability to install brews from both
URLs and local file paths.

This repository contains UNOFFICIAL brews that have not been accepted into
the master branch.

These brews can be installed via the raw GitHub URLs, or by cloning this
repository locally and installing off the local disk. For more details see
the "using" section below.

This replaces the "Homebrew Duplicates" branch which was hosted on adamv's
fork of Homebrew itself.


# Contents

Brews in this repository are broken out as described below.

  * duplicates:
    These brews duplicate OS X functionality, though may provide newer or
    bug-fixed versions.

    Homebrew policy is to allow duplicates only in some specific cases.

  * versions:
    These brews provide mulitple versions of the same software package.

    Homebrew policy is to maintain a single, stable version of a given
    package.

  * binary:
    These brews provide only binary installs.

  * non-free:
    These brews provide non-free software.

  * other:
    Other brews that have not been accepted into master.


# Using

There are two ways to install packages from this repository.

## Using Raw URLs

First you need to get your hands on the raw URL. For example, the raw url for
the princexml formula is:

`https://github.com/adamv/homebrew-alt/raw/master/non-free/princexml.rb`


Pass that URL as a parameter to the `brew install` command, like so:

`brew install https://github.com/adamv/homebrew-alt/raw/master/non-free/princexml.rb`

## Cloning the Repository

Clone the repository to somewhere that you'll remember:

`git clone https://github.com/adamv/homebrew-alt.git /usr/local/LibraryAlt`

This example creates a `LibraryAlt` directory under `/usr/local`.

Then to install a formula pass the full path to the formula into the
`brew install` command. Here's another example that installs princexml:

`brew install /usr/local/LibraryAlt/non-free/princexml.rb`
