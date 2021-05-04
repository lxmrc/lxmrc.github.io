---
layout: post
title: Remove file from last commit
date: 2021-05-04 11:46 +1000
---

```
git reset --soft HEAD~1
git reset HEAD path/to/unwanted_file
git commit -c ORIG_HEAD  
```

([via StackOverflow](https://stackoverflow.com/questions/12481639/remove-files-from-git-commit))
