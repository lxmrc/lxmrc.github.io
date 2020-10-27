---
layout: post
title: Automating tests with Guard on Ubuntu
tags:
- til
- rails
- linux
---
I was going through the Rails Tutorial by Michael Hartl and got this error trying to set up automated tests with Guard:

```
$ bundle exec guard                             
13:47:58 - INFO - Guard::Minitest 2.4.6 is running, with Minitest::Unit 5.11.3!
FATAL: Listen error: unable to monitor directories for changes.            
Visit https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers for info on how to fix this.
```

This message helpfully provides [a link explaining exactly how to fix the problem](https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers) but I want to write this TIL to explain what's going on (a la [the Feynman Technique](https://mattyford.com/blog/2014/1/23/the-feynman-technique-model)).

The Listen gem (which I guess is part of or comes with the Guard gem) uses a Linux kernel subsystem called `inotify` to monitor directories for changes. Apparently on Ubuntu the default limit on the number of files `inotify` can monitor is 8192. The directroy I was trying to set up Guard in contained 20652 files. 

The command that the Listen docs provide will permanently increase this limit and allow Guard to run:

```
$ echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```
