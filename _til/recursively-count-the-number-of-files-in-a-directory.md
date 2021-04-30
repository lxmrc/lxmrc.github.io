---
layout: post
title: Recursively count the number of files in a directory
date: 2020-10-13 14:20 +1100
---

You want to know how many files are in a directory, and all of its subdirectories? 

```shell
find . -type f | wc -l
```
