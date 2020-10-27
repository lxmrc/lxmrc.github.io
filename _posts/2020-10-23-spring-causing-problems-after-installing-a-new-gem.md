---
layout: post
title: Spring causing problems after installing a new gem
date: 2020-10-23 16:10 +1100
tags: ["til", "rails", "rails-tutorial"]
description: Sometimes Spring is doing it. Turn it off and on again.
---

**TL;DR: Sometimes Spring is doing it. Turn it off and on again:** 

```bash
$ spring stop
```

(It'll turn itself back on the next time you run `rails server`).

I was going through the [Ruby on Rails tutorial](https://railstutorial.org/) and reached a section where we had to install the gem `will_paginate`. I added the appropriate line to the `Gemfile`, ran `bundle install`, restarted the Rails server, the same way I'd done for every other gem I'd added so far, but I kept getting `undefined method 'paginate'`. 

I opened up the Rails console to try calling `paginate` on the `User` model in the same way the book had demonstrated and kept getting the same thing.

I double-checked to make sure I hadn't typed anything wrong, I opened up eight StackOverflow tabs, I even checked the reference version of the app I'd cloned from Michael Hartl's GitHub for some crucial difference I'd missed but to no avail.

Eventually I remembered we had this thing running called [Spring](https://github.com/rails/spring) to preload the application and keep it in memory in order to speed up our tests. It greeted me every time I ran `rails c` with something like `Running via Spring preloader in process 40538`, I'd kind of learned to ignore it. I also remembered the book mentioning that it could sometimes cause problems and to restart it if it did.

So that's what I did and that finally solved it.

Initially I did it the Linux way (`ps aux | grep spring`, `kill <pid>`) but there's a proper way to do it:

```bash
$ spring stop
```
