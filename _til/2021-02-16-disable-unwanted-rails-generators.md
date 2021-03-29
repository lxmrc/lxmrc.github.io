---
layout: post
title: Disable unwanted Rails generators
date: 2021-02-16 10:39 +1100
---

```ruby
    config.generators do |g|
      g.helper false
      g.view_specs false
      g.routing_specs false
      g.request_specs false
    end
```
