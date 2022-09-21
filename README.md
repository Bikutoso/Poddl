# Poddl - Japanese Audio Downloader
Download Japanese audio clips from languagepod101

## Table of contents
* [Introduction](#introduction)
* [Reason for project](#reason-for-project)
* [How to install](#how-to-install)
* [Usage](#usage)

## Introduction
Poddl creates an easy way to download japanese audio files for study.  
It can be used to download induvidual words, or many using csv files.
## Reason for project
Poddl started as a simple python script to simplify my study of Japanese.

In June of 2021 i decided to learn Ruby, and poddl was a perfect small first project.  
This project is not perfect, and will continue to develop as my knowlage about Ruby and programming in general improves
## How to install
Build package with `gem build poddl.gemspec`  
Then install with `gem install poddl-1.1.0.gem` 


## Usage

```
poddl [options] [kana] [kanji]
Specific options:
    -d, --directory path             Path to download directory
    -i, --input file                 CSV file with words
    -v, --[no-]verbose               Run verbosely

Common options:
    -h, --help                       Show this message
    -V, --version                    Show version
```

Interactive: `poddl`  
Command Line: `poddl わたし 私`, `poddl イギリス`   
CSV Input: `poddl -i /tmp/infile.csv`

### environment variables
Poddl uses environment variables as a way to configure settings

**Variables:**
* `PODDL_PATH` (default: `~/Downloads`), Save location
* `PODDL_THREADS` (default: `2`), Number of threads in CSV Input to downlad files
* `PODDL_URL`, Download URL, uses the query `?kanji=%s&kana=%s`
* `PODDL_HASH` SHA-256 for missing file

