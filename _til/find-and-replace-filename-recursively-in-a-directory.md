---
layout: post
title: Find and replace filename recursively in a directory
date: 2021-04-29 10:45 +1000
---

```
find -name "*bad_string*" -exec rename 's/bad_string/good_string/' {} ";" 
```

Note: not all systems have `rename`.

([via StackOverflow](https://stackoverflow.com/questions/9393607/find-and-replace-filename-recursively-in-a-directory))
