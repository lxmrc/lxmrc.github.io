---
layout: post
title: 'Exercism: Acronym'
date: 2020-09-23 11:32 +1000
tag: exercism
image: '/images/bbbq.jpg'
---

This straightforward exercise is about converting phrases into acronyms.
<!--description-->
This ugly chunk of code got the first four tests passing:

```ruby
module Acronym
  def self.abbreviate(phrase)
    phrase.split.map do |word| 
      word[0].upcase
    end.join
  end
end
```

But it turned "Complementary metal-oxide semiconductor" into "CMS" instead of "CMOS". Clearly we need a regular expression to split the phrase both on spaces and on hyphens, I think the simplest one would be `/\w+/`:

```ruby
  def self.abbreviate(phrase)
    phrase.scan(/\w+/).map do |word| 
      word[0].upcase
    end.join
  end
```

This gets the remainder of the tests passing but unfortunately the code is still ugly and not at all "rubonic" (like how Python people say "pythonic", this is a word now).

One thing we can do is make the regular expression do the work of finding the first letter instead of doing `word[0]`.

```ruby
  def self.abbreviate(string)
    string.scan(/\b\w/).map do |letter| 
      letter.upcase
    end.join
  end
```

The regular expression `/\b\w/` looks for a ["word boundary"](https://www.regular-expressions.info/wordboundaries.html) followed by a letter, in other words it matches on letters that are at the start of a word. Now we can get rid of the `map` statement; instead of upcasing each letter and then joining them we can join them and then upcase:

```ruby
  def self.abbreviate(string)
    string.scan(/\b\w/).join.upcase
  end
```

Much better.

![Thumbs Up](/assets/img/thumbs_up.gif)
