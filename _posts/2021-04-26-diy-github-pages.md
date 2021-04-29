---
layout: post
title: DIY GitHub Pages
date: 2021-04-26 19:24 +1000
description: How I host this site.
---

Most people just use GitHub Pages to host their Jekyll site, but not me. I love to pay for things I can get for free. 

I used [Git hooks](https://githooks.com/) to replicate the automated deployment functionality of GitHub Pages so I can push to a repo and have my site build and deploy automatically.

>Git hooks are scripts that Git executes before or after events such as: commit, push, and receive. Git hooks are a built-in feature - no need to download anything. Git hooks are run locally.

Git hooks live in the `.git/hooks` directory in your repo. There will already be a number of examples in there, you can either delete them or leave them be. 

The files are named after different events Git recognizes; the script inside each file will execute whenever the corresponding event occurs. You would think that `post-commit` is the event we want but it's actually `post-receive`.

Create a file called `post-receive` in the `.git/hooks` directory on the remote machine containing the following script:

