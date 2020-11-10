---
layout: post
title: Grokking sessions, cookies and authentication
date: 2020-10-22 14:24 +1100
tags:
- feynman technique
description: Going Feynman mode on chapters 8 and 9 of the Rails Tutorial.
---
You might've heard of [the Feynman Technique](https://mattyford.com/blog/2014/1/23/the-feynman-technique-model). The idea is to explain something you've just learned as though you were teaching it to someone else. It's easy to think you understand something when you really don't and the Feynman Technique forces you to discover the gaps in your understanding.

When I reached chapter 9 of [Michael Hartl's Rails Tutorial](https://www.learnenough.com/ruby-on-rails-6th-edition) I could feel myself getting fooled into thinking I was understanding when I really wasn't so I decided to apply the Feynman Technique and write out a thorough explanation of it for myself.

---

## What's a session?

The functionality to have users log in and out in an application can be implemented through the concept of "sessions". For a user to be currently logged in means that there is a session associated with that particular user; as long as this session exists the user is not required to log in again. When the user logs out the session is destroyed and the user will be asked to authenticate again on their next visit.

But where do sessions happen in the context of an application? Are they objects in memory, are they records in a table?  

In our case, sessions are represented by a file (a cookie) on the user's machine which the user sends with every request. It's like a ticket the client shows to the server that says "hey, I'm still me, don't make me log in again". 

The _server_ sends this file to the _client_ the first time they authenticate and then the client can send it back with each request. The only thing the cookie needs to contain for now is the user's ID, so that the server knows which particular already-logged-in-user you are.

You might be wondering, what's to stop someone from changing the user ID in their cookie and pretending to be someone else? Wouldn't that allow them to log in as anyone they want? Fortunately thanks to Rails the cookie is encrypted and cryptographically signed by the server before it is saved on the user's machine.  

So how do we actually implement these session things in our application?

From the Rails Tutorial:

>It’s convenient to model sessions as a RESTful resource: visiting the login page will render a form for _new_ sessions, logging in will _create_ a session, and logging out will _destroy_ it. __Unlike the Users resource, which uses a database back-end (via the User model) to persist data, the Sessions resource will use cookies,__ and much of the work involved in login comes from building this cookie-based authentication machinery.

