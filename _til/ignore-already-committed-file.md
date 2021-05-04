---
layout: post
title: Ignore already committed file
date: 2021-05-05 09:24 +1000
---

```
# Remove the files from the index (not the actual files in the working copy)
git rm -r --cached .

# Add these removals to the Staging Area...
git add .

# ...and commit them!
git commit -m "Clean up ignored files"
```

https://www.git-tower.com/learn/git/faq/ignore-tracked-files-in-git/
