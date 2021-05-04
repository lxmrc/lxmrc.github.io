---
layout: post
title: Move recent commits to a separate branch
date: 2021-05-04 15:07 +1000
---

```
# Note: Any changes not committed will be lost.
git branch newbranch      # Create a new branch, saving the desired commits
git reset --hard HEAD~3   # Move master back by 3 commits (Make sure you know how many commits you need to go back)
git checkout newbranch    # Go to the new branch that still has the desired commits
```

(via [StackOverflow](https://stackoverflow.com/questions/1628563/move-the-most-recent-commits-to-a-new-branch-with-git))
