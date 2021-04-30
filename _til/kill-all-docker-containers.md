---
layout: post
title: Kill all Docker containers
date: 2021-04-30 12:42 +1000
---

```
docker kill $(docker ps -q)
```

(via [ktamas77](https://gist.github.com/evanscottgray/8571828#gistcomment-1830482))
