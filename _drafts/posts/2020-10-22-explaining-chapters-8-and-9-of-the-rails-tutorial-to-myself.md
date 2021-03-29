---
layout: post
title: Grokking sessions, cookies and authentication
date: 2020-10-22 14:24 +1100
tags: ["feynman technique"]
description: Going Feynman mode on chapters 8 and 9 of the Rails Tutorial.
---

You've probably heard of [the Feynman Technique](https://mattyford.com/blog/2014/1/23/the-feynman-technique-model), but in case you haven't, the idea is to explain something you've just learnt as though you were teaching it to someone else. It solidifies your knowledge and more importantly helps you identify gaps in it. It's easy to think you understand something when you really don't, or as Richard Feynman put it: "The first principle is that you must not fool yourself — and you are the easiest person to fool."

When you get to a point in your explanation where you realize you don't actually know how the thing works, you've just identified something you thought you knew but didn't really.

When I reached chapter 9 of [Michael Hartl's Rails Tutorial](https://www.learnenough.com/ruby-on-rails-6th-edition) I could feel myself getting fooled into thinking I was understanding when I really wasn't so I decided to Feynman-Technique it and write out a thorough explanation of it for myself.

---

### What's a session?

Log in/log out functionality can be implemented through the concept of "sessions". For a user to be currently logged in means that there is a session associated with that particular user; as long as this session exists the user is not required to log in again. When the user logs out the session is destroyed and the user will be asked to authenticate again on their next visit.

At first I imagined that sessions would exist as objects in our application, maybe like users but without anything being persisted in the database. This was wrong and the truth is way more abstract and subtle.

Sessions are represented by a file (a cookie) on the user's machine which the user sends with every request. It's like a ticket the client shows to the server that says "hey, I'm still me, don't make me log in again". The server sends this file to the client the first time they authenticate and then the client can send it back with each request. The only thing the cookie needs to contain is the user's ID, so that the server knows which particular already-logged-in-user you are.

But if the user ID is stored on the user's machine then what's to stop someone from editing the cookie and changing the user ID, effectively allowing them to log in as any user they want? Fortunately the cookie is encrypted and signed by the server before it is saved on the user's machine. (Maybe I'll do a blog post on encryption and digital signatures later.)

So how do we actually implement these session things in our application?

From the Rails Tutorial:

>It’s convenient to model sessions as a RESTful resource: visiting the login page will render a form for _new_ sessions, logging in will _create_ a session, and logging out will _destroy_ it. __Unlike the Users resource, which uses a database back-end (via the User model) to persist data, the Sessions resource will use cookies,__ and much of the work involved in login comes from building this cookie-based authentication machinery.

