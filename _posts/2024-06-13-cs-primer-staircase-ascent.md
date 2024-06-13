---
layout: post
title: 'CS Primer: Staircase Ascent'
date: 2024-06-13 13:35 +1000
---

The first problem in the [CS Primer](https://csprimer.com) data structures and algorithms course is "Staircase Ascent":

>How many different ways could one ascend a staircase of *n* steps, taking 1, 2 or 3 steps at a time?

```ruby
# 01_staircase_ascent.rb

  def staircase_ascent(n)
    return 1 if n == 0
    return 1 if n == 1
    return 2 if n == 2

    staircase_ascent(n - 1) + staircase_ascent(n - 2) + staircase_ascent(n - 3)
  end
```

```ruby
# 01_staircase_ascent_test.rb

require 'minitest/autorun'
require_relative '01_staircase_ascent'

class StaircaseAscentTest < Minitest::Test
  def test_staircase_ascent
    assert_equal 1, staircase_ascent(1)
    assert_equal 2, staircase_ascent(2)
    assert_equal 4, staircase_ascent(3)
    assert_equal 7, staircase_ascent(4)
    assert_equal 13, staircase_ascent(5)
    assert_equal 24, staircase_ascent(6)
    assert_equal 44, staircase_ascent(7)
    assert_equal 81, staircase_ascent(8)
    assert_equal 149, staircase_ascent(9)
    assert_equal 274, staircase_ascent(10)
  end
end
```
