---
layout: post
title: Setup guard-rspec in new gem
date: 2021-04-29 10:26 +1000
---

```ruby
guard :rspec, cmd: 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
```

([from the `guard-rspec` docs](https://github.com/guard/guard-rspec#standard-rubygem-project))
