---
layout: post
title: Recursively count the number of files in a directory
date: 2020-10-13 14:20 +1100
tags: ["til", "linux", "bash"]
---

You want to know how many files are in a directory, *and* all of its subdirectories? How dare you?

```
$ find . -type f | wc -l
```
