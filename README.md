# Poddl - Japanese Audio Downloader
Download Japanese audio clips from languagepod101.
## Table of contents
* [Introduction](#introduction)
* [How to install](#how-to-install)
* [Usage](#usage)
## Introduction
Poddl was created to easily download audio clips for learning Japanese.

Poddl is written in Ruby
## How to install
*NOTE: Change DEFAULT_PATH in `lib/poddl/options.rb` to suit your system*

Build package with `gem build poddl.gemspec`

Then install with `gem install poddl-*.*.gem`
## Usage
poddl [options] kana [kanji]

Example 1: `poddl わたし 私`

Example 2: `poddl イギリス`

Example 3: `poddl -d /tmp みせ 店`
