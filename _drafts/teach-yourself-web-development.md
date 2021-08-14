---
layout: post
title: Teach Yourself Web Development
description: Or "how I would teach myself web development today"
---
## Survey the terrain

I think Barbara Oakley talks about this in A Mind For Numbers[^1] in the context of reading textbooks: look at the table of contents, flip through the chapters, look at the subheadings, diagrams and so on, before actually diving into the text and trying to understand it.

Get a rough idea of the core concepts and how they relate to each other, how those concepts are themselves broken down into smaller concepts, the order in which they are traditionally taught etc. Build a scaffold onto which you can hang concepts as you are fleshing them out.

Here's a rough breakdown of the three major flavours of web development roles. The separation between these roles is not really clear cut and you should aim to have a bit of experience with all of these areas and then specialize in one:

- **Front-end**: The user interface, the part of a web app that people see and interact with, the part that runs on the user's computer, in their browser. Written in HTML, CSS and JavaScript. In the current year that almost always means using a front-end framework like React, Angular, Vue etc. (which you work with by writing HTML/CSS/JavaScript).
- **Back-end**: The part of the web app that users don't see, that runs on the server. Processes requests from the front-end, handles the logic of the application, talks to the database and APIs and issues a response. Written in a server-side language e.g.: Ruby, Python, JavaScript, Java, C#, Go, etc. Also important to understand relational databases and SQL.
- **Devops**: A "meta" discipline that's kind of hard to explain to people with no software development experience. Ostensibly a union of "development" and "operations" - operations being everything that happens between code being written and code running in production. Overlaps a lot with back-end development but especially focused on Linux, "the cloud" and automating all that "operations" stuff.

The website [Roadmap.sh](https://roadmap.sh) provides roadmaps for each of these three fields, which provide the kind of high-level overview I'm recommending but which should also be taken with a massive fistful of salt. Here is their roadmap for learning back-end development:

<a href="https://roadmap.sh/backend"><img src="/assets/backend_roadmap.png"/></a>

This map is alright but there's also a lot wrong with it. The number of things on it might give you the impression that there is an overwhelming amount to learn. Some of the things on there are important subjects that you will have to spend a lot of time learning, others are helpful concepts to be aware of that you might want to spend 10 minutes reading about. As an example I really don't think you need to read Roy Fielding's paper, a 180-page [literal doctoral dissertation](https://www.ics.uci.edu/~fielding/pubs/dissertation/fielding_dissertation.pdf), to understand REST APIs.

Here is my attempt at a roadmap:

1. **HTML/CSS/JavaScript**
1. **Command line and Git**
1. **A backend framework**
1. **Test-driven development**
1. **Relational databases and SQL**
1. **Servers, deployment, CI/CD**

---

[^1]: This book is worth a read by the way. [There is also a MOOC version of it.](https://www.coursera.org/learn/learning-how-to-learn).
