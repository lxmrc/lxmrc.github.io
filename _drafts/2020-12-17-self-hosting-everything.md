---
layout: post
title: Self-Hosting Everything
description: In which I make deploying a Rails app more complicated on purpose
date: 2020-12-17 12:39 +1000
---
I recently finished reading [Active Rails by Ryan Bigg](https://activerails.com). The final chapter covers setting up continuous integration with GitHub Actions and deploying the application to Heroku, but having deployed a couple of Rails apps to Heroku before I decided this time around to try deploying to my own server with Capistrano.

Before long I was also setting up a self-hosted S3 bucket with MinIO, running CI pipelines on my own server with GitLab and writing a Dockerfile to optimise the process. Why? I thought it would be interesting and that I would learn a lot.

I'm not sure if this would be useful to anyone else but in the interest of [creating "learning exhaust"](https://www.swyx.io/learn-in-public), here is how I did all of that. This isn't exactly a step-by-step guide, more of a personal retrospective for my own benefit; if you do want to try any of this yourself there is a list of all the resources I used at the end of this article.

1. [Deploying with Capistrano](#deploying-with-capistrano)
1. [Self-hosted object storage with MinIO](#self-hosted-object-storage-with-minio)
1. [Self-hosting a GitLab instance and CI runner](#self-hosting-a-gitlab-instance-and-ci-runner)
1. [Automating tests and deployment](#automating-tests-and-deployment)
1. [Final thoughts](#final-thoughts)

---

## Deploying with Capistrano

For the initial setup I followed [the GoRails guide on deploying a Rails app to Ubuntu 20.04](https://gorails.com/deploy/ubuntu/20.04). It covers every step of deploying a Rails app so I won't go over it	 again here, but I'll briefly mention a couple of things I learned from going through the process.

### What's an application server?

The first unfamiliar thing in this process for me was [Phusion Passenger](https://phusionpassenger.com) and the concept of an 'application server'. I'd already installed Nginx, so what was this second type of 'server' for? How come I'd never had to worry about it when running `rails server` on my own machine?

[The Passenger docs do a good job of answering the question](https://www.phusionpassenger.com/docs/tutorials/fundamental_concepts/ruby/#how-passenger-fits-in-the-stack):

>Nginx and Apache are web servers. They provide HTTP transaction handling and serve static files. *However, they are not Ruby application servers and cannot run Ruby applications directly.* That is why Nginx and Apache are used in combination with an application server, such as Passenger.
>
>*Application servers make it possible for Ruby apps to speak HTTP. Ruby apps (and frameworks like Rails) can't do that by themselves.* On the other hand, application servers typically aren't as good as Nginx and Apache at handling HTTP requests. The devil is in the details: Nginx and Apache are better at handling I/O security, HTTP concurrency management, connection timeouts, etc. That's why, in production environments, application servers are used in combination with Nginx or Apache.

My initial notion of the elements that make up a basic web application stack was: operating system, database, application, web server. The application server seems to constitute a fifth thing that sits between the application and web server.

### Rails credentials and environment variables

I also ran into some trouble when it came to Rails credentials and storing them in production. [This blog post by Jason Swett](https://www.codewithjason.com/understanding-rails-secrets-credentials/) was helpful in understanding just what exactly Rails credentials even are:

>The credentials feature is a way of storing secrets that you don’t want to keep in plaintext, like AWS credentials for example. (In fact, the one and only thing I keep in my main Rails project’s credentials are my Active Storage AWS credentials.)

The credentials needed to access my S3 bucket are stored in the encrypted file `config/credentials.yml.enc` and the key for decrypting that file is in `config/master.key`, which should never be checked into version control. [The right way of getting this key onto a production server is to save it as an environment variable](https://12factor.net/config), which the GoRails guide uses `rbenv-vars` to achieve.

Apart from those two things I was basically able to follow the steps without any trouble and had my app deployed and running on my own server. The next step was to get file uploads working correctly.

---	

## Self-hosted object storage with MinIO

<img src="/assets/aws.jpeg" width="75%" style="margin: 1em auto;"/>
<div	 class="caption">via <a href="https://twitter.com/SimpsonsOps">Simpsons Against DevOps</a></div>

At this point I was hooked on spinning up servers and doing things myself, so I wondered, what is the category of thing that Amazon S3 falls into and can I host my own version of it? The answer is object storage and yes.

[This video explains what object storage is and what differentiates it from the more traditional types of storage.](https://www.youtube.com/watch?v=3r9RGJ0_Bls&t=1468s) S3 is Amazon's object storage service, but other cloud providers offer compatible services based on the S3 API, and it's also possible to host your own, which is what I did using [MinIO](https://min.io).

It was surprisingly simple, I just followed [this guide by Kevin Stevenson](https://gist.github.com/kstevenson722/e7978a75aec25feaa6ad0965ec313e2d) and was up and running within a few minutes. Configuring Active Storage to work with my MinIO bucket was also pretty straightforward thanks to [this post by Kevin Jalbert](https://kevinjalbert.com/rails-activestorage-configuration-for-minio/). It turns out everything is easier when someone else already wrote down how to do it.

The Rails app was now fully functional, able to handle file uploads and store them on my imitation S3 bucket.

---

## Self-hosting a GitLab instance and CI runner


![](/assets/rube-goldberg.png)
<div	 class="caption">How CI/CD works.</div>

The next thing I wanted to do was automate the process of running the test suite and deploying to production after every commit. [GitHub Actions](https://github.com/features/actions) is an easy way to do this but I'd already made up my mind to spin up as much of my own infrastructure as possible. 

Setting up a GitLab instance was pretty painless: [you can just install it as a package on Ubuntu.](https://about.gitlab.com/install/#ubuntu) This will create a self-hosted, self-managed instance of GitLab. [To run CI pipelines you need a GitLab Runner](https://docs.gitlab.com/runner/), which has to run on its own separate server. I went with Docker for my "executor", the thing the runner uses to run stuff.

<img src="/assets/containers.jpeg" width="75%" style="margin: 1em auto;"/>
<div	 class="caption">via <a href="https://twitter.com/SimpsonsOps">Simpsons Against DevOps</a></div>

Once Docker's installed you can [install GitLab Runner](https://docs.gitlab.com/runner/install/linux-repository.html#installing-the-runner) and [register it](https://docs.gitlab.com/runner/register/index.html), i.e. bind it to your GitLab instance so it can run your pipelines on it. 

I don't really have much else to say about this part; I just followed GitLab's docs and pretty soon I was ready to start continuously integrating and deploying.

---

## Automating tests and deployment

[Here are the basic GitLab CI/CD concepts according to the docs](https://docs.gitlab.com/ee/ci/pipelines/index.html):

>Pipelines are the top-level component of continuous integration, delivery, and deployment.
>
>Pipelines comprise:
>
>- Jobs, which define *what* to do. For example, jobs that compile or test code.
>- Stages, which define *when* to run the jobs. For example, stages that run tests after stages that compile the code. 
>
>Jobs are executed by runners. Multiple jobs in the same stage are executed in parallel, if there are enough concurrent runners.
>
>If *all* jobs in a stage succeed, the pipeline moves on to the next stage.
>
>If *any* job in a stage fails, the next stage is not (usually) executed and the pipeline ends early.

In my case I just wanted the test suite to run, and if all the tests were green, to deploy the new version of the app to production. That means two stages, one for testing and one for deployment.

To get started with GitLab CI/CD you need a `.gitlab-ci.yml` file in the root of the repository. Here is what my first working version eventually looked like after a lot of troubleshooting:

```yml
image: ruby:2.7.1

test:
  stage: test
  script:
    # Install Node and Yarn.
    - curl -sL https://deb.nodesource.com/setup_12.x | bash -
    - curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    - echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
    - apt-get update
    - apt-get install nodejs yarn
    # Install Firefox and geckodriver.
    - apt-get -y install firefox-esr
    - wget https://github.com/mozilla/geckodriver/releases/download/v0.27.0/geckodriver-v0.27.0-linux64.tar.gz
    - tar -xvzf geckodriver-v0.27.0-linux64.tar.gz -C /usr/bin
    - bundle install
    - bundle exec rake yarn:install
    - bundle exec rake db:create
    - bundle exec rspec
```

The first line specifies the image to build the container from. The next part defines a job called `test` which will be part of a stage also named `test`. The job itself is essentially just a list of the commands you would need to run in your terminal to get the tests running after cloning the repo:
1. Install the dependencies
2. Create the database
3. Run the tests

The headless Firefox part was necessary for the Capybara tests to work.

One thing I quickly discovered in the process is that running `bundle install` every time gets old fast, and Node, Yarn and headless Firefox also seem like things that should already be in there ready to go when the container starts running.

Fortunately, GitLab provides per-repo container registries for uploading your own container images, so I decided to write my own Dockerfile to address this. [This post by Brian Morearty](http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker/) helped me figure out how to cache gems inside the container image; apart from that I was able to just copy the `apt-get` lines from my `.gitlab-ci.yml` into my Dockerfile:

```dockerfile
FROM ruby:2.7.1

# Install Node and Yarn.
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn 
RUN yarn install --check-files

# Install Firefox and geckodriver.
RUN apt-get -y install firefox-esr
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.27.0/geckodriver-v0.27.0-linux64.tar.gz
RUN tar -xvzf geckodriver-v0.27.0-linux64.tar.gz -C /usr/bin

# Run bundle install.
COPY Gemfile* ./
RUN bundle install
```

This allowed me to shave the `.gitlab-ci.yml` file down to this:

```yml
image: "gitlab.lxmrc.com/lxmrc/ticketty"

test:
  stage: test
  variables:
    RAILS_ENV: "test"
  script:
    - bundle exec rake assets:precompile
    - bundle exec rake db:create
    - bundle exec rspec
```

And reduced the build time from 8:21 to 1:50. I now had automated tests running, the final step was automating the deployment. 

To deploy manually I just run `bundle exec cap production deploy`, but deploying from inside the GitLab Runner container takes a little more than that. 

The production server doesn't let just anyone deploy to it, it uses SSH for authentication, so I needed to somehow get an SSH key into the container that Capistrano would be running in. Figuring this out in the first place probably took the longest out of any other step in the process but [I eventually found this blog post by Jamie Tanna explaining the right way to do it](https://www.jvt.me/posts/2017/01/25/gitlab-ci-capistrano/).

Here are the basic steps summarized:

1. You can make environment variables available in the container from the GitLab UI: [add the *private key* as an environment variable called `$SSH_PRIVATE_KEY`](https://docs.gitlab.com/ee/ci/variables/README.html#create-a-custom-variable-in-the-ui) and it'll become accessible from your `.gitlab-ci.yml`.
2. [Add the *public key* as a 'deploy key' from the GitLab UI.](https://docs.gitlab.com/ee/user/project/deploy_keys/#project-deploy-keys) This will allow Capistrano, running inside GitLab Runner, to read from the repo so it can then deploy.
3. Use `ssh-agent` in the `.gitlab-ci.yml` to authenticate.

Here's what that looks like:

```
deploy:
  stage: deploy
  script:
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | ssh-add -
    - bundle exec cap production deploy 
```

That's it! Everything finally worked. It was overkill for a demo app with no users but it worked.

---

## Final thoughts

I've skipped over a lot of troubleshooting and missteps and the hours spent on StackOverflow it took to get everything working. Overall this whole process took me around 12-16 hours over several days, and it was getting past two or three specific errors that took up the bulk of that time. I should have written about them but I'd forgotten what they were by the time I decided to write this.

This would have taken much longer, or I might not have been able to do it at all, if it weren't for other people's blog posts and videos, so thank you bloggers and YouTubers.

Since writing this post I've taken all of these servers down (because money). Next time I do something like this I'd love to try automating some of it with Ansible.

Here are all the important links I used again in one spot if you want to do any of this yourself:

1. [Deploy Ruby On Rails to Ubuntu 20.04 Focal Fossa](https://gorails.com/deploy/ubuntu/20.04)
2. [Setup MinIO on Ubuntu 20.04 LTS with Let's Encrypt SSL](https://gist.github.com/kstevenson722/e7978a75aec25feaa6ad0965ec313e2d)
3. [Rails ActiveStorage Configuration for Minio](https://kevinjalbert.com/rails-activestorage-configuration-for-minio/)
3. [Download and install GitLab](https://about.gitlab.com/install/#ubuntu)
4. [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
5. [Install GitLab Runner](https://docs.gitlab.com/runner/install/linux-repository.html#installing-the-runner) and [register it](https://docs.gitlab.com/runner/register/index.html)
6. [How to Skip Bundle Install When Deploying a Rails App to Docker if the Gemfile Hasn’t Changed](http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker/)
7. [Continuous Delivery with Capistrano and GitLab Continuous Integration](https://www.jvt.me/posts/2017/01/25/gitlab-ci-capistrano/)
