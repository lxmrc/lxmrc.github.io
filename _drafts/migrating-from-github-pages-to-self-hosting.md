---
layout: post
title: Migrating from GitHub Pages to self-hosting
description: Automating Jekyll deployments with Git hooks.
---
Yesterday I decided to move this site from GitHub Pages to my own VPS. In particular I thought it would be cool to figure out how to replicate the automated deployment functionality of GitHub Pages and have the site automatically build and deploy every time I pushed to the remote Git repo. Here's how I did it.

(**Note**: This guide assumes a basic familiarity with the Unix command line, Git, etc. It also assumes you have [a Jekyll site in a GitHub repository](https://docs.github.com/en/free-pro-team@latest/github/working-with-github-pages/creating-a-github-pages-site-with-jekyll).)

1. [Setting up the server](#setting-up-the-server) 
1. [Installing dependencies](#installing-dependencies)
1. [Serving the site via Nginx](#serving-the-site-via-nginx)
1. [Automating deployment](#automating-deployment)

---

## Setting up the server

If this isn't your first rodeo then by all means skip to the next section, otherwise follow the steps below to set up your server.

A lot of people recommend DigitalOcean but I've gone with Linode because they have a data centre in Australia. [Here's a link for $100 free credit when you sign up](https://www.linode.com/lp/brand-free-credit/).


### Creating a server

Once you've signed up to Linode and logged in, create "a linode" (a server) from the Linode dashboard:

![](/assets/linode1.gif)

Select Ubuntu 20.04 LTS as your distribution:

![](/assets/linode2.png)

Choose the region closest to you:

![](/assets/linode3.png)

The Nanode 1GB Plan will do for serving a static site:

![](/assets/linode4.png)

Give it a descriptive label or just use the default one, create a root password, click create on the right hand side and wait for your server to be created. Once the icon says "Running" you're ready to log in:

![](/assets/linode5.png)

### Logging in and creating a user

To log in to the server you'll need its IP address.

![](/assets/linode6.png)

Open up a terminal and SSH into your server:

```shell
ssh root@123.456.789
```
Type `yes` when it asks if you're sure you want to continue, then enter the password you used when you created the server.

![](/assets/ubuntu1.png)

Congrats, you're now logged in as `root`, but you should create a non-root user with administrative privileges and use this account instead of `root` to do everything from now on. :

```shell
adduser alex
```

Give it a password but don't worry about the full name, room number, etc. 

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

Next we need to install all the things needed to run Jekyll and host a website.

### Ruby

We're going to install Ruby with [`rbenv`](https://github.com/rbenv/rbenv), but we need to install a number of packages before we can do that:

```shell
sudo apt update
sudo apt install git curl autoconf bison build-essential \
    libssl-dev libyaml-dev libreadline6-dev zlib1g-dev \
    libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
```

*Now* we can install `rbenv`:

```shell
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL
```
There are a few things going on here but explaining them in detail is outside the scope of this article. [Here's a good article that explains some of what's going on.](https://linuxhint.com/path_in_bash/)

We should now be able to install Ruby with `rbenv`:

```shell
rbenv install 2.7.2
```

This might take a while. In fact, the server will probably have a time limit for how long you can be logged in without doing anything and it might kick you out before Ruby's done installing, but the installation will continue regardless and you can simply log back in.

Once it's done, set the global Ruby version:

```shell
rbenv global 2.7.2
```
Then verify that Ruby installed correctly:

```shell
ruby -v
```

And if you see something like this:

```shell
ruby 2.7.0p0 (2019-12-25 revision 647ee6f091) [x86_64-linux-gnu]
```

...then you've successfully installed Ruby.

### Nginx

To host a website you'll need a web server. We're going to use Nginx:

```shell
sudo apt install -y nginx
```

Verify that it's running:

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

Clone a copy of your Jekyll site from the GitHub repository onto your server:

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

This is the directory where Nginx looks for a site by default. Build your Jekyll site inside this directory:

```shell
bundle exec jekyll build --destination /var/www/html
```

If everything went smoothly, when you enter the IP address of your server into the browser, instead of the default Nginx page you should hopefully see your Jekyll site!

---

## Automating deployment

Now that you've got your site up and running you can set it up to update automatically whenever you push changes from your local machine, the way GitHub Pages does.

Essentially we want to run `bundle exec jekyll build --destination /var/www/html` automatically on the server every time we `git push` changes to it.

In the repo on your local machine, add a Git remote pointing to the version on the remote server, e.g.:

```shell
git remote add jekyll alex@123.456.789:/home/alex/blog
```

We can use [Git hooks](https://githooks.com/) to run our Jekyll build every time we push changes:

>Git hooks are scripts that Git executes before or after events such as: commit, push, and receive. Git hooks are a built-in feature - no need to download anything. Git hooks are run locally.

Git hooks live in the `.git/hooks` directory in your repo. There will already be a number of examples in there, you can either delete them or leave them be. 

The files are named after different events Git recognizes; the script inside the file will execute whenever that particular event occurs. If you're like me you might have assumed the event we're looking for is `post-commit` but it turns out it's actually `post-receive`.

We want to create a file called `post-receive` in the `.git/hooks` directory on the remote machine containing the following script:

```bash
#!/bin/bash
GIT_REPO=$HOME/your-username.github.io
TMP_GIT_CLONE=/tmp/jekyll
PUBLIC_WWW=/var/www/html

git clone --single-branch --branch master $GIT_REPO $TMP_GIT_CLONE
/home/alex/.rbenv/shims/jekyll build --source $TMP_GIT_CLONE --destination $PUBLIC_WWW
rm -rf $TMP_GIT_CLONE
```

This is a simple Bash script that clones your repo to a temporary folder, runs `jekyll build`[^1] on it to build the site in the directory that Nginx is serving from and then cleans up the temporary folder.

For it to run you'll need to make the script executable:

```shell
chmod +x .git/hooks/post-receive
```

This won't work if you're checked in to master so you'll also need to checkout a different branch:

```shell
git checkout -b tmp
```

Make some changes on your local machine, commit and push:

```shell
git push jekyll
```

And your site should update instantly! Pretty cool I reckon.

## Next steps

This would all be much more impressive if you didn't have to use the IP address to visit your site. Why not [buy a domain](https://www.namecheap.com/) and [set up your DNS records](https://www.namecheap.com/support/knowledgebase/article.aspx/9837/46/how-to-connect-a-domain-to-a-server-or-hosting#viaip)?

You should probably also take further steps to secure your server [by disabling root login, using SSH keys to log in instead of a password](https://youtu.be/5JvU9wcZSbA&t=296) and [setting up a firewall](https://www.youtube.com/watch?v=Pn_1rb4oF5I).

---
[^1]: I'm not sure why but this won't work unless you use the full path to the Jekyll executable.
