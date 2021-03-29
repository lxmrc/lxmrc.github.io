---
layout: post
title: 'Exercism: Word Count'
tags: exercism
description: One failing test, ah ah ah...
---
I think this one of the first really great exercises where you can learn a good two or three things by reading some of the highly-starred solutions.

>Given a phrase, count the occurrences of each word in that phrase.

The exercise expects a `Phrase` class which can be initialized with the phrase and which has an instance method `#word_count`. `#word_count` should return a hash whose keys are the words in the phrase and values are the number of times each word appears in that phrase, e.g.:

>For the input "olly olly in come free"
>
>#=> { olly: 2,
>in: 1,
>come: 1,
>free: 1 }

Here is an implementation that relies on only the basic enumerable method `#inject`:

```ruby
class Phrase
  def initialize(phrase)
    @words = phrase.split
  end

  def word_count
    @words.inject(Hash.new(0)) do |count, word|
      count[word] += 1 
      count
    end
  end
end
```

It gets the first three tests passing but it could be improved by utilizing some more advanced enumerable methods.

But first, the tests are forcing us to:

1. split not just on spaces but also on commas and newlines 
1. ignore punctuation
1. normalize case
1. include words that contain apostrophes 
1. ignore quotation marks around words
1. ignore multiple spaces

Sounds like a regular expression:

```ruby
  def initialize(phrase)
    @words = phrase.downcase.scan(/\b[\w']+\b/)
  end
```

This gets all the tests green which means we can go back and refactor `#word_count` and learn about those more advanced enumerable methods I mentioned. The first one I want to talk about is `#each_with_object`:

```ruby
  def word_count
    @words.each_with_object(Hash.new(0)) do |word, count|
      count[word] += 1 
    end
  end
```

The main difference is that unlike `#inject` it doesn't expect you to explicitly return the object you're injecting into (a.k.a.: the 'memo' or 'accumulator') from every block. 

Another important difference to note is that the order of the arguments passed to the block has changed (`word` and `count` have been swapped around).

It seems to me that `#each_with_object` is more appropriate when starting with an empty collection, whereas you would stick with `#inject` for mutating an existing collection.

That's great but not the most dramatic improvement. Here's what seems to me like the official, canonical, idiomatic way of writing a method like `#word_count`:

```ruby
  def word_count
    @words.group_by(&:itself).transform_values(&:count)
  end
```

There is no way I would have arrived at this myself, I discovered it by looking at the highly starred solutions after I'd submitted mine. There are at least two or three weird things going on here. [I assume the reader is already familiar with the `&:method` syntax](https://thoughtbot.com/blog/blocks-procs-and-enumerable).

I'd used `#group_by` before, it groups the elements in a collection based on the result of the block, for example:

```ruby
words = %w[here are some words of various lengths]

words.group_by { |word| word.length }

#=> {4=>["here", "some"], 3=>["are"], 5=>["words"], 2=>["of"], 7=>["various", "lengths"]}
```

It turns out `words.group_by(&:itself)` is the same as `words.group_by { |word| word }` which would return:

```ruby
words.group_by { |word| word }

#=> {"here"=>["here"], "are"=>["are"], "some"=>["some"], "words"=>["words"], "of"=>["of"], "various"=>["various"], "lengths"=>["lengths"]}
```

But why would I want to do that? It might make more sense with some repeated words:

```ruby
words = %w[here are some words and here are some more and here is one more word]

words.group_by(&:itself)

#=> {"here"=>["here", "here", "here"], "are"=>["are", "are"], "some"=>["some", "some"], "words"=>["words"], "and"=>["and", "and"], "more"=>["more", "more"], "is"=>["is"], "one"=>["one"], "word"=>["word"]}
```

Interesting, now, bear with me here but what if, theoretically, there were a method that could somehow *transform* all of the *values* of a hash according to the block you passed it?
Behold `#transform_values`:

```ruby
words.group_by(&:itself).transform_values(&:count)

#=> {"here"=>3, "are"=>2, "some"=>2, "words"=>1, "and"=>2, "more"=>2, "is"=>1, "one"=>1, "word"=>1}
```

In case it's not clear `#transform_values` is iterating over the arrays of grouped words and transforming them into their `count`. Here's the same thing more explicitly:

```ruby
words.group_by(&:itself).transform_values { |values| values.count }

#=> {"here"=>3, "are"=>2, "some"=>2, "words"=>1, "and"=>2, "more"=>2, "is"=>1, "one"=>1, "word"=>1}
```
