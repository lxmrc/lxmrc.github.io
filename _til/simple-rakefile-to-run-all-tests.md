---
layout: post
title: Simple Rakefile to run all tests
date: 2021-05-17 13:25 +1000
---

For when you're using Minitest instead of RSpec:

```ruby
require "rake/testtask"

Rake::TestTask.new do |t|
  t.test_files = FileList["test/*_test.rb"]
end
desc "Run tests"

task default: :test
```

Run `rake` to run all tests.
