---
layout: post
title: Fix SQLite gem problem on Ubuntu
date: 2020-09-23 13:18 +1000
tags: ["til", "sqlite", "bundler", "linux"]
---
Every time I run `bundle` in a Rails app for the first time on a fresh Ubuntu install<!--more--> I get one of these:

```
An error occurred while installing sqlite3 (1.4.2), and Bundler cannot continue.                                                                      
Make sure that `gem install sqlite3 -v '1.4.2' --source 'https://rubygems.org/'` succeeds before bundling.
```

The standard `sqlite3` package won't do, you need to install the dev version:
```
$ sudo apt-get install libsqlite3-dev
```
