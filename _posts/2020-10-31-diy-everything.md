---
layout: post
title: DIY Everything
date: 2020-10-31 14:10 +1100
description: Deploying a Rails app to a VPS via self-hosted GitLab CI/CD
---

1. (Non-continuous) deployment with Capistrano
1. Self-hosted object storage with MinIO
1. Self-hosting a GitLab instance and CI runner
1. Writing a CI pipeline to automate tests
1. Writing a Dockerfile
1. Automating deployment

This week I reached the final chapter in Ryan Bigg's book [Active Rails](https://activerails.com), deployment!

Having deployed Rails apps to Heroku before and being curious about all things Linux and devops I decided to get my hands dirty and deploy the app to my own VPS instead. I followed [this guide from Chris Oliver](https://gorails.com/deploy/ubuntu/20.04) and learned how to serve a Rails app via NGinx and Passenger and deploy it with Capistrano, my first time doing any of this (needless to say I ran into problems).

The chapter also walked through configuring Active Storage with S3 but I'd already foolishly squandered by AWS free tier last year, so I did a little research and realized I could host my own S3-compatible object storage with [MinIO](https://min.io) (after I figured out what "object storage" means).

At this point I was a fiend for DIY and self-hosting. If it was convenient and abstracted complex things away from me I didn't want anything to do with it, so after following along with Ryan's guide to continuous deployment with GitHub Actions I thought: "OK but what if it was self-hosted?"

Enter GitLab, which is actually incredibly easy to host on your own. Once I had my instance ready to go I learned from the GitLab CI documentation that "you should install GitLab Runner on a machine that’s separate from the one that hosts the GitLab instance". No worries, another opportunity to spin up a server. This one would be where the CI actually happened, using magic and Docker and so on.

Speaking of which, once I had my GitLab Runner ready to go and started trying to get a pipeline to run the test suite I discovered another opportunity to make things harder for myself: the pipeline was `bundle install`ing all my gems every time it ran - wasteful, not devops-y at all. I wanted my gems ready to go inside the Docker image the container was being built from. It was time to write a Dockerfile.
