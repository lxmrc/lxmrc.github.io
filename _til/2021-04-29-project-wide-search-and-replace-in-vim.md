---
layout: post
title: Project-wide search-and-replace in vim
date: 2021-04-29 10:38 +1000
---

Generate list of files:

```
:args `ag -l 'bad_string' .`
```

Run search and replace against list of files:

```
:argdo %s/bad_string/good_string/g | w
```

([via kevinjalbert](https://gist.github.com/kevinjalbert/8dc0c27351b0a4f60335))
