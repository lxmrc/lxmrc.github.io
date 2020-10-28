---
layout: post
title: Migrating from GitHub Pages to self-hosting
date: 2020-10-28 20:50 +1100
description: Automating Jekyll deployments with git hooks.
---

Yesterday I decided to move this site from [GitHub Pages](https://pages.github.com/) to my own server. In particular I thought it would be cool to figure out how to replicate the automated deployment functionality of GitHub Pages and have the site automatically build and deploy every time I pushed to a remote git repo. It was surprisingly easy, here's how I did it:

After setting up a server running Ubuntu 20.04 I had to install the dependencies. To install Ruby via rbenv I followed [this guide from Linuxize](https://linuxize.com/post/how-to-install-ruby-on-ubuntu-20-04/):

>The ruby-build script installs Ruby from the source. To be able to build Ruby, install the required libraries and compilers:
>
>```shell
>$ sudo apt update
>```
>
>```shell
>$ sudo apt install git curl autoconf bison build-essential \
>    libssl-dev libyaml-dev libreadline6-dev zlib1g-dev \
>    libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
>```
>
>The simplest way to install the rbenv tool is to use the installation shell script. Run the following curl or to download and execute the script:
>
>curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-ins

>To start using rbenv, you need to add `$HOME/.rbenv/bin` to your `PATH`.
>
>```shell
>    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
>    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
>    source ~/.bashrc
>```

Then I installed Ruby 2.7.2 and made it the global Ruby version:

```shell
$ rbenv install 2.7.2
$ rbenv global 2.7.2
```

Next I installed NGinx following [this guide from DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-20-04):

<strong style="background: yellow;">TODO: Rest of the article.</strong>

---

Create a new remote:

```shell
git remote add linode alex@lxmrc.com:/home/alex/lxmrc.com
```

Create a post-receive git hook `/home/alex/lxmrc.com/.git/hooks/post-receive`:

```bash
#!/bin/bash
GIT_REPO=$HOME/lxmrc.com
TMP_GIT_CLONE=/tmp/lxmrc.com
PUBLIC_WWW=/var/www/lxmrc.com/html

git clone --single-branch --branch master $GIT_REPO $TMP_GIT_CLONE
/home/alex/.rbenv/shims/jekyll build --source $TMP_GIT_CLONE --destination $PUBLIC_WWW
rm -rf $TMP_GIT_CLONE
```

Switch to a dummy branch:

```shell
$ git checkout -b dummy
```

Push and behold the magic.
