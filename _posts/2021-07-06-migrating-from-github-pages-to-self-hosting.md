---
layout: post
title: Migrating from GitHub Pages to self-hosting
description: Automating static site deployments with Git hooks
date: 2020-07-06 11:30 +1000
---

>**Update:** As of 2021 this site is hosted on [Vercel](https://vercel.com) because servers cost money, but I'm leaving this article up for posterity.

Yesterday I decided to move this site from GitHub Pages to my own VPS because I love to pay for things I can get for free. In particular I thought it would be cool to figure out how to replicate the automated deployment functionality of GitHub Pages and have the site automatically build and deploy every time I pushed to the remote Git repo. Here's how I did it.

This article assumes that you have:
  - [a Jekyll site in a GitHub repository](https://docs.github.com/en/free-pro-team@latest/github/working-with-github-pages/creating-a-github-pages-site-with-jekyll)
  - [a server running Ubuntu 20.04 and NGINX](https://gorails.com/deploy/ubuntu/20.04) 

You only need to follow the "Create a server", "Install Ruby", and "Install NGINX & Passenger" sections of that article, and only do the NGINX part, we don't need Passenger. I would also recommend just creating a user with your first name rather than `deploy`.

And you will probably also want your own [domain name](https://www.namecheap.com/) [pointing to that server](https://www.namecheap.com/support/knowledgebase/article.aspx/9837/46/how-to-connect-a-domain-to-a-server-or-hosting#viaip) but you can always do that afterwards.

---

## Serving the site via Nginx

Clone a copy of your Jekyll site from the GitHub repository onto your server (`cd` into `/home/your-username` if you're not there already):

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

If everything went smoothly, when you enter the IP address of your server into the browser, instead of the default Nginx page you should see your Jekyll site.

---

## Automating deployment

Now that you've got your site up and running let's set it up to build automatically whenever you push new changes.

Essentially we want to run `bundle exec jekyll build --destination /var/www/html` automatically on the server every time we `git push` changes to it.

In the repo on your own machine, add a Git remote pointing to the remote server, e.g.:

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

This is a simple Bash script that clones your repo to a temporary folder, runs `jekyll build`[^2] on it to build the site in the directory that Nginx is serving from and then cleans up the temporary folder.

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

[^1]: There are a few things going on here but explaining them in detail is outside the scope of this article. [Here's a good article that explains some of it.](https://linuxhint.com/path_in_bash/)
[^2]: I'm not sure why but this won't work unless you use the full path to the Jekyll executable.
