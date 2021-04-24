---
layout: post
title: Works On My Machine
description: Troubleshooting a failing test in CI
date: 2021-04-24 14:25 +1000
---
Recently my GitHub Actions pipeline was failing because of this test:

```
1) Users can delete comments if the post belongs to them
  Failure/Error: find("#delete-#{comment.id}").click

  Capybara::Ambiguous:
    Ambiguous match, found 2 elements matching visible css "#delete-3"
```

The failing test was checking that users could delete comments on their posts:

```ruby
RSpec.feature "Users can delete comments", type: :feature do
  let(:alice) { FactoryBot.create(:user) }
  let(:bob) { FactoryBot.create(:user) }

  let!(:post) { FactoryBot.create(:post, author: alice) }
  let!(:comment) { FactoryBot.create(:comment, body: "Great post!", author: bob, post: post) }

  # ...

  scenario "if the post belongs to them", js: true do
    login_as(alice)
    visit post_path(post)

    expect(page).to have_content("Great post!")

    accept_confirm do
      find("#delete-#{comment.id}").click
    end

    expect(page).to_not have_content("Great post!")
  end
```

But this same test was green when I ran it locally. I decided to drop a `save_and_open_page` in there to see what was going on. `save_and_open_page` is a Capybara method that saves a snapshot of a page so you can open it in the browser and see what Capybara sees.

![](/assets/save_and_open_page_1.png)

Capybara was telling me there were two of those trash can buttons on the page with the same ID. But the ones I was looking at definitely had distinct IDs, one was `#delete-627`, the other was `#delete-78`...

![](/assets/wait_a_minute.gif)

But buttons for deleting comments and buttons for deleting posts probably shouldn't have the same ID format -- if a comment and a post happened to have the same ID in the database and appeared on the same page[^1] it would lead to exactly the kind of ambiguous match Capybara was reporting. 

That's probably what was happening in the CI environment: the post and the comment both had the same ID in the database, meaning there were in fact two buttons on the page with the same CSS ID, one for deleting the post and one for deleting the comment.

I wanted to take a look at the version of that `save_and_open_page` snapshot being generated in the CI environment to make sure but CI jobs run in containers and containers are ephemeral; once the job has run everything disappears into the void. 

If you want to snatch files or directories from the jaws of the void before your CI pipeline finishes running you need to create what they call an "artifact". 

Luckily there is an official [upload-artifact GitHub Action](https://github.com/actions/upload-artifact) for doing exactly this. Here's what I added to my `.github/workflows/tests.yml` file:

```YAML
    - name: Upload Capybara snapshots
      uses: actions/upload-artifact@v2
      if: failure()
      with:
        name: capybara
        path: tmp/capybara/
``` 

This allowed me to download an archive of the `tmp/capybara` directory (where Capybara saves its snapshots) as it was in CI after the tests had run. The `if: failure()` part is important: without it the workflow will never get as far as this step because the failing test prevents it.

So I ran the pipeline, downloaded the snapshot artifact and imagine my shock when I discovered two buttons with the ID `#delete-3`, one for deleting a comment and another for deleting a post.

But why was the test passing on my machine? I think something about the way IDs are assigned to factories by FactoryBot. 

In the CI environment the post and comment causing the trouble were consistently being given the ID 3 every time. On my machine the IDs were being incremented across each test, i.e.: the first time the tests ran the post or comment ID would be 1, the next time it would be 2 and so on. I'd started running my tests for posts long before I ever had tests for comments so their IDs were out of sync: comment IDs were up to 78 while post IDs were already in the 600s. This wasn't happening in the CI environment because each container was starting from scratch with a fresh database.

I fixed this by installing [DatabaseCleaner](https://github.com/DatabaseCleaner/database_cleaner) and factory IDs were now starting from 1 each time the tests ran, the same way they were in CI, so I finally had the tests failing the same way in both environments. To make them pass I changed the CSS IDs for the comment deletion buttons to `#delete-comment-1` to differentiate them from the ones for posts.

---

[^1]: This is kind of confusing. I'm talking about two different kinds of ID. One is the CSS type of ID, for the two buttons on the page. The other is the ID of the comments and posts in the database.
