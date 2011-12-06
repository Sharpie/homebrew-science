# Overview

This repository contains **unofficial** formulae for [Homebrew](https://github.com/mxcl/homebrew).

(This replaces the `Homebrew Duplicates` branch that used to live under [adamv's
main Homebrew fork](https://github.com/adamv/homebrew).)


## Quick Start

To install homebrew-alt formulae, use one of the following:

 * `brew install [raw GitHub URL]`
 * `brew install [full path to formula from your local homebrew-alt clone]`

For more details, see below: "Installing homebrew-alt Formulae".



# How This Repository Is Organized

  *   **duplicates**<br>
      These brews duplicate OS X functionality, though may provide newer or
      bug-fixed versions.  

      (Homebrew policy discourages duplicates, except in some specific cases.)

  *   **versions**<br>
      These formulae provide mulitple versions of the same software package.

      (Homebrew policy is to maintain a single, stable version of a given
      package.)

  *   **binary**<br>
      These formulae provide binary-only installations.

  *   **non-free**<br>
      These formulae provide non-free software.

  *   **other**<br>
      Other formulae that haven't been accepted into master.



# Installing homebrew-alt Formulae

There are two methods to install packages from this repository.


## Method 1: Raw URL

First, find the raw URL for the formula you want. For example, the raw URL for
the `princexml` formula is:

```
    https://github.com/adamv/homebrew-alt/raw/master/non-free/princexml.rb
```


Once you know the raw URL, simply use `brew install [raw URL]`, like so:

```
    brew install https://github.com/adamv/homebrew-alt/raw/master/non-free/princexml.rb
```


## Method 2: Repository Clone

First, clone this repository.  Be sure to choose a good location!  

For example, clone to `LibraryAlt` under `/usr/local`:

```
    git clone https://github.com/adamv/homebrew-alt.git /usr/local/LibraryAlt
```


Once you've got your clone, simply use `brew install [full path to formula]`.

For example, to install `princexml`:

```
    brew install /usr/local/LibraryAlt/non-free/princexml.rb
```


That's it!
