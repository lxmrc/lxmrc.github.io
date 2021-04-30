---
layout: post
title: 'Ruby''s #tap method'
date: 2020-09-29 13:19 +1000
---

>Ruby's tap method allows you to "tap into" a method chain, modify an object and receive that same object as the result.

[Implementing Ruby's Tap Method \| Leigh Halliday](https://www.leighhalliday.com/implementing-rubys-tap-method)

I saw this for the first time in [this awesome solution to the Luhn exercise on exercism.io](https://exercism.io/tracks/ruby/exercises/luhn/solutions/8d2791d779774fd4b0e1a9529cf895af):

```ruby
class Luhn
  def self.valid?(input)
    input
      .delete(' ')
      .tap { |s| return false unless s[/\A\d\d+\z/] }
      .chars
      .map(&:to_i)
      .reverse
      .map.with_index { |d, i| i.odd? ? d * 2 : d }
      .map { |d| d > 9 ? d - 9 : d }
      .sum
      .modulo(10)
      .zero?
  end
end
```
