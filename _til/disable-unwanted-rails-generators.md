---
layout: post
title: Disable unwanted Rails generators
date: 2021-02-16 10:39 +1100
---

Don't you just hate those?

```ruby
# config/application.rb

config.generators do |g|
  g.stylesheets       false
  g.javascripts       false
  g.helper            false
  g.assets            false
  g.view_specs        false
  g.fixtures          false
  g.view_specs        false
  g.helper_specs      false
  g.routing_specs     false
  g.request_specs     false
  g.controller_specs  false
end
```
