---
layout: post
title: Migrating from GitHub Pages to self-hosting
date: 2020-10-28 20:50 +1100
description: Automating Jekyll deployments with git hooks.
---

Yesterday I decided to move this site from GitHub Pages to my own VPS. In particular I thought it would be cool to figure out how to replicate the automated deployment functionality of GitHub Pages and have the site automatically build and deploy every time I pushed to the remote git repo. Here's how I did it.

(**Note**: This guide assumes a basic familiarity with the Unix command line, git, etc. It also assumes you have [a Jekyll site in a GitHub repository](https://docs.github.com/en/free-pro-team@latest/github/working-with-github-pages/creating-a-github-pages-site-with-jekyll).)

1. [Setting up the server](#setting-up-the-server) 
1. [Installing dependencies](#installing-dependencies)
1. [Serving the site via Nginx](#serving-the-site-via-nginx)
1. [Automating deployment](#automating-deployment)

---

## Setting up the server

If this isn't your first rodeo then by all means skip to the next section, otherwise follow the steps below to set up your very own server in the cloud.

A lot of people recommend DigitalOcean but I've gone with Linode because they have a data centre in Australia and DigitalOcean don't. [Here's a link for $100 free credit when you sign up](https://www.linode.com/lp/brand-free-credit/). [^1]


### Creating a server

Once you've signed up to Linode and logged in, create "a linode" (a server) from the Linode dashboard:

![](/assets/linode1.gif)

Select Ubuntu 20.04 LTS as your distribution:

![](/assets/linode2.png)

Choose the region closest to you:

![](/assets/linode3.png)

Go with the Nanode 1GB Plan, you won't need anything more for serving a static site:

![](/assets/linode4.png)

Give it a descriptive label or just use the default one. 

Create a root password and don't forget it, you'll need it to log in. 

Click create on the right hand side and wait for your server to be created. Once the icon says "Running" you're ready to log in:

![](/assets/linode5.png)

### Logging in and creating a user

To log in to the server you'll need to copy its IP address:

![](/assets/linode6.png)

Open up a terminal and SSH into your server:

```shell
ssh root@123.456.789
```
Type `yes` when it asks if you're sure you want to continue, then enter the password you used when you created the server.

![](/assets/ubuntu1.png)

Congrats, you're now logged in as root, but you should create a non-root user with administrative privileges, e.g.:

```shell
adduser alex
```

We'll use this account instead of root for everything we do from now on. Give it a password but don't worry about the full name, room number, etc. 

Add your new user to the `sudo` group to give it administrative privileges:

```shell
adduser alex sudo
```

You can now log out (`exit` or Ctrl+D) and log back in as your new user:

```shell
ssh alex@123.456.789
```
---

## Installing dependencies

Next we need to install all the things we need to run Jekyll and host a website.

### Ruby

We're going to install Ruby with [`rbenv`](https://github.com/rbenv/rbenv). First update your package list:

```shell
sudo apt update
```
Managing packages requires root privileges, which is why these commands must be prepended with `sudo` and why you'll be prompted for your password.

Next, install the packages we'll need to run `rbenv` and install Ruby:

```shell
sudo apt install git curl autoconf bison build-essential \
    libssl-dev libyaml-dev libreadline6-dev zlib1g-dev \
    libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
```

Finally install `rbenv`:

```shell
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL
```

There are a few things going on here but explaing them in detail is outside of the scope of this article. Rest assured however, these lines do in fact install `rbenv`.

Now we can install Ruby with `rbenv`:

```shell
rbenv install 2.7.2
```

This might take a while. In fact, the server has a time limit for how long you can be logged in without doing anything and it might kick you out before Ruby's done installing, but the installation will continue regardless and you can simply log back in.

Once it's done, set the global Ruby version to 2.7.2:

```shell
rbenv global 2.7.2
```
Then verify that Ruby installed correctly:

```shell
ruby -v
```

You should see something like this:

```shell
ruby 2.7.0p0 (2019-12-25 revision 647ee6f091) [x86_64-linux-gnu]
```

### Nginx

To host a web site you need to have a web server set up. We're going to use Nginx:

```shell
sudo apt install -y nginx
```

Then verify that it's running:

```shell
sudo systemctl status nginx
```
You should hopefully see something like this:

![](/assets/ubuntu2.png)

That means your web server's running and ready to respond to requests. If you enter the IP address of your server in your browser URL bar you should see this:

![](/assets/nginx1.png)

Congrats, you have a publicly facing web server accessible by anyone on the internet. Now let's replace that default page with your Jekyll site.

---

## Serving the site via Nginx

Clone down a copy of your Jekyll site from the GitHub repository:

```shell
git clone https://github.com/your-username/your-username.github.io.git
```

`cd` into the newly cloned directory:

```shell
cd your-username.github.io
```

Install Jekyll and any other dependencies:

```shell
bundle install
```

You'll need to give yourself ownership of the `/var/www/html` directory to put stuff in it:

```shell
sudo chown alex:alex /var/www/html
```

This is the directory where Nginx looks for a site by default. Build your Jekyll site inside the `/var/www/html` directory:

```shell
bundle exec jekyll build --destination /var/www/html
```

If everything went smoothly, when you enter the IP address of your server into the browser, instead of the default Nginx page you should now see your Jekyll site.

---

## Automating deployment

Now that you've got your site up and running you'll want it to update automatically the way GitHub Pages does, whenever you push changes from your local machine.

Essentially we want to run `bundle exec jekyll build --destination /var/www/html` automatically on the server every time we `git push` changes to it.

In the repo on your local machine, add a git remote pointing to the version on the remote server, e.g.:

```shell
git remote add jekyll alex@123.456.789:/path/to/jekyll/site
```

We can use [git hooks](https://githooks.com/) to run our Jekyll build every time we push changes:

>Git hooks are scripts that Git executes before or after events such as: commit, push, and receive. Git hooks are a built-in feature - no need to download anything. Git hooks are run locally.

Git hooks live in the `.git/hooks` directory in your repo. There will already be a number of examples in there, you can either delete them or leave them be. 

The files are named after different events git recognizes; the script inside the file will execute whenever that particular event occurs. (If you're like me you might have assumed the event we're looking for is `post-commit` but no, that's something else. The event we want is `post-receive`.)

We want to create a file called `post-receive` in the `.git/hooks/` directory on the remote machine containing the following bash script:

```bash
#!/bin/bash
GIT_REPO=$HOME/your-username.github.io
TMP_GIT_CLONE=/tmp/jekyll
PUBLIC_WWW=/var/www/html

git clone --single-branch --branch master $GIT_REPO $TMP_GIT_CLONE
jekyll build --source $TMP_GIT_CLONE --destination $PUBLIC_WWW
rm -rf $TMP_GIT_CLONE
```

This is a simple bash script that clones your repo to a temporary folder, runs `jekyll build` on it to build the site in the directory that Nginx is serving from and then cleans up the temporary folder.

You'll also need to checkout a different branch because git won't let you do this while you're checked in to master. 

```shell
git checkout -b dummy
```

Make some changes on your local machine, commit and push, and behold the magic.

```shell
git push jekyll
```

## Next steps

This would all be much more impressive if you didn't have to use the IP address to visit your site. Why not [buy a domain](https://www.namecheap.com/) and [set up DNS](https://www.namecheap.com/support/knowledgebase/article.aspx/9837/46/how-to-connect-a-domain-to-a-server-or-hosting#viaip)?

You should probably also take further steps to secure your server [by disabling root login, using SSH keys to log in instead of a password](https://youtu.be/5JvU9wcZSbA&t=296) and [setting up a firewall](https://www.youtube.com/watch?v=Pn_1rb4oF5I).

---
[^1]: I don't get anything if you use this, in case you care about that.
