---
layout: post
title: Migrating from GitHub Pages to self-hosting
date: 2020-10-28 20:50 +1100
description: Automating Jekyll deployments with git hooks.
---

Yesterday I decided to move this site from [GitHub Pages](https://pages.github.com/) to my own server. In particular I thought it would be cool to figure out how to replicate the automated deployment functionality of GitHub Pages and have the site automatically build and deploy every time I pushed to a remote git repo. Here's how I did it.

These steps assume you already have a server running and serving your Jekyll site with Nginx.

In the repo on your local machine, add a remote pointing to the repo on the remote server, e.g.:

```shell
git remote add lxmrc alex@lxmrc.com:/home/alex/lxmrc.com
```

Create a [post-receive git hook](https://githooks.com/): 

>Git hooks are scripts that Git executes before or after events such as: commit, push, and receive. Git hooks are a built-in feature - no need to download anything. Git hooks are run locally.

Git hooks live in the `.git/hooks` directory in your repo. There will already be a number of examples in there, you can either delete them or leave them be. The files are named after different events git recognizes; the script inside the file will execute whenever that particular event occurs. (If you're like me you might assume the event we're looking for is `post-commit` but in actual fact it's `post-receive`. Don't ask me why.)

We want to create a file called `post-receive` in the `.git/hooks/` directory on the remote machine, e.g.:

```bash
#!/bin/bash
GIT_REPO=$HOME/lxmrc.com
TMP_GIT_CLONE=/tmp/lxmrc.com
PUBLIC_WWW=/var/www/lxmrc.com/html

git clone --single-branch --branch master $GIT_REPO $TMP_GIT_CLONE
jekyll build --source $TMP_GIT_CLONE --destination $PUBLIC_WWW
rm -rf $TMP_GIT_CLONE
```

This is a simple bash script that clones your repo to a temporary folder, runs `jekyll build` on it and builds the site in the directory that Nginx is serving from.

You'll also need to checkout a different branch because git won't let you do this while you're checked in to master (again, don't ask me why).

```shell
git checkout -b dummy
```

Make some changes on your local machine, commit and push, and behold the magic.
