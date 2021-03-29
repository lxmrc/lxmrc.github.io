---
layout: post
title: 'Exercism: Resistor Color Duo'
date: 2020-09-22 13:56 +1000
tag: exercism
---

>[Part of a series of posts going through the Ruby exercises on](/tag/exercism) [exercism.io](https://exercism.io).

![Resistance is Futile](/assets/img/borg.jpg)

Resistors have color-coded bands to denote their resistance values. Each band has a position and a numeric value. For example, a brown band (value 1) followed by a green band (value 5), translates to 15. 
<!--description-->
The colors are mapped to the numbers from 0 to 9 in the sequence: black, brown, red, orange, yellow, green, blue, violet, grey, white.

The program should take color names as input and output a two digit number. If the input includes more than two colors it should disregard the extra ones.

Here was my initial solution:

```ruby
module ResistorColorDuo
  VALUES = %w[black brown red orange yellow green blue violet grey white]

  def self.value(colors)
    colors.first(2).map { |c| VALUES.index(c) }.join.to_i
  end
end
```
