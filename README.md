# Poddl - Japanese Audio Downloader
Download Japanese audio clips from languagepod101

## Table of contents
* [Introduction](#introduction)
* [Reason for project](#reason-for-project)
* [How to install](#how-to-install)
* [Usage](#usage)

## Introduction
Poddl was created to easily download audio clips for learning Japanese.  
Poddl is written in Ruby.

## Reason for project
The project was started to help me study Japanese.  
The first version worked but was a messy Python script.

In June of 2021 i started to learn Ruby after issues i had with Python.  
Poddl was a good choice for a first project in Ruby.  
So i'm still learning and the quality of the code might not always be the best.

## How to install
Download gem file from download page and install with `gem install poddl-1.0.0.gem` 

Create the `PODDL_PATH` environment variable to set a default path. (default: `~/Downloads`)

## Usage
poddl [options] kana [kanji]

Example 1: `poddl わたし 私`  
Example 2: `poddl イギリス`  
Example 3: `poddl -d /tmp みせ 店`
