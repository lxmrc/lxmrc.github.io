---
layout: post
title: Configure Capybara to run tests in headless mode
date: 2020-10-28 21:20 +1100
description: Making integration tests less annoying.
---

I've been going through the book [Active Rails](https://activerailsbook.com/) by Ryan Bigg.

```shell
$ sudo apt install firefox-geckodriver
```
`/spec/support/headless_firefox.rb`

```ruby
RSpec.configure do |config|
  Capybara.register_driver :firefox do |app|
    Capybara::Selenium::Driver.new(app, browser: :firefox)
  end

  Capybara.register_driver :headless_firefox do |app|
    options = Selenium::WebDriver::Firefox::Options.new
    options.headless! 

    Capybara::Selenium::Driver.new app,
      browser: :firefox,
      options: options
  end

  case ENV['GUI']
  when 'true', '1'
    Capybara.javascript_driver = :firefox
  else
    Capybara.javascript_driver = :headless_firefox
  end
end
```

Tests will be headless by default now.

In case you do want the browser to pop up and annoy you:

```shell
$ GUI=1 bundle exec rspec
```
