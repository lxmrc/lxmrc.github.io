---
layout: post
title: 'RSpec: describe, context, feature, scenario?'
---
In RSpec, `context` is an alias for `describe` so they are functionally equivalent. The only difference is that `context` isn't available at the top level, i.e. you can't start a spec file with a `context` block.

`feature` and `scenario` are actually part of Capybara, not RSpec.
