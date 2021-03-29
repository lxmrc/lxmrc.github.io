---
layout: post
title: 'Exercism: Scrabble Score'
tags: exercism
image: "/images/kwyjibo.jpg"
---
>Calculate the scrabble score for a given word.
<!--more-->

The first thing that nagged me about this one was whether or not to type out each letter-score pair one by one or find some cleverer, DRY-er way of doing it. I wanted some concise way of assigning multiple keys to the same value. I opted to just type them out to begin with but I did discover a clever way after looking through the highly starred solutions.

But first, here was my initial solution:

```ruby
class Scrabble
  SCORES = { 
    'A' => 1, 'N' => 1,
    'B' => 3, 'O' => 1,
    'C' => 3, 'P' => 3,
    'D' => 2, 'Q' => 10,
    'E' => 1, 'R' => 1,
    'F' => 4, 'S' => 1,
    'G' => 2, 'T' => 1,
    'H' => 4, 'U' => 1,
    'I' => 1, 'V' => 4,
    'J' => 8, 'W' => 4,
    'K' => 5, 'X' => 8,
    'L' => 1, 'Y' => 4,
    'M' => 3, 'Z' => 10
  }

  def initialize(word)
    @letters = word.to_s.upcase.scan(/[A-Z]/)
  end

  def score
    @letters.sum { |letter| SCORES[letter] }
  end

  def self.score(word)
    new(word).score
  end
end
```

I discovered from the community solutions that you can rewrite the `#scores` method like so:

```ruby
  def score
    @letters.sum(&SCORES)
  end
```

At least that's my understanding of the magic happening here. And here is the clever way of writing the scores hash I mentioned:

```ruby
SCORES = {
    /[AEIOULNRST]/ => 1,
    /[DG]/ => 2,
    /[BCMP]/ => 3,
    /[FHVWY]/ => 4,
    /[K]/ => 5,
    /[JX]/ => 8,
    /[QZ]/ => 10
}
```

Obviously this means the `#score` method has to change, we can no longer use `&SCORES` to access the values because the keys are regular expressions now.

It also occurred to me from looking at the other solutions that it might be more appropriate to store the word as an instance variable, rather than the letters, and to do the work of splitting into letters in `#score`:

```ruby
  def initialize(word)
    @word = word.to_s.upcase
  end

  def score 
    SCORES.sum do |letters, value|
      @word.scan(letters).count * value
    end 
  end
```

This alternative `#score` method is nifty but I think it's less explicit, it takes me a few seconds to figure out what it's doing. I'm also not sure how I feel about iterating over `SCORES` rather than the letters. It's not the way a human thinks about scoring a word in scrabble.
