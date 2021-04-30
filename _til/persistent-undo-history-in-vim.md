---
layout: post
title: Persistent undo history in vim
date: 2021-04-24 15:15 +1000
---

You can configure vim to have persistent undo history, so you can make a change, close and reopen the file, even shutdown and restart, and still have the undo history.

In your `.vimrc`:

```
set undofile
set undodir=$HOME/.vimundo/
```

Make sure you create that `$HOME/.vimundo/` directory first.

via [StackOverflow](https://askubuntu.com/questions/292/how-do-i-get-vim-to-keep-its-undo-history/4247#4247)
