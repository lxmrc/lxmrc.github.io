---
layout: post
title: 'Exercism: Matrix'
date: 2020-09-24 09:38 +1000
tag: exercism
image: '/images/morpheus.jpg'
---

>You think that's blog you're reading?

-- Morpheus, possibly

What if I told you, given a string representing a matrix of numbers, to return the rows and columns of that matrix?

Here was my initial implementation that had all the tests passing:

```ruby
class Matrix
  attr_reader :rows, :columns

  def initialize(string)
    @rows = string.split("\n").map do |row|
      row.split.map(&:to_i)
    end
    @columns = rows.transpose
  end
end
```

I don't like that `map` inside of a `map` though and I want it to fit on one line. Turns out `each_line` exists and does the same thing as `split("\n")` only nicer looking.

```ruby
class Matrix
  attr_reader :rows, :columns

  def initialize(matrix)
    @rows = matrix.each_line.map { |line| line.split.map(&:to_i) }
    @columns = rows.transpose
  end
end
```

There's not much more I can say about this one. Did you know you can use `Array#transpose` to transpose a two-dimensional array?

>In linear algebra, the transpose of a matrix is an operator which flips a matrix over its diagonal; that is, it switches the row and column indices of the matrix A by producing another matrix, often denoted by AT (among other notations).
>
>-- [Transpose - Wikipedia](https://en.wikipedia.org/wiki/Transpose)

