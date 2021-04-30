---
layout: post
title: inotify and Guard
date: 2020-10-13 14:04 +1100
---

I got this error trying to set up automated tests with Guard:

```
$ bundle exec guard                             
13:47:58 - INFO - Guard::Minitest 2.4.6 is running, with Minitest::Unit 5.11.3!
FATAL: Listen error: unable to monitor directories for changes.            
Visit https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers for info on how to fix this.
```

This message helpfully provides [a link explaining exactly how to fix the problem](https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers):

```
$ echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

Apparently on Ubuntu the default limit on the number of files `inotify` can monitor is 8192. The directroy I was trying to set up Guard in contained 20652 files. 
