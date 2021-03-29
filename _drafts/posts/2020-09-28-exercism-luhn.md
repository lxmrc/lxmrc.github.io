---
layout: post
title: 'Exercism: Luhn'
date: 2020-09-28 14:21 +1000
tag: exercism
---

>[Part of a series of posts going through the Ruby exercises on](/tag/exercism) [exercism.io](https://exercism.io).

![Credit Card](/assets/img/creditcard.jpg)

<!--description-->

## Instructions

This one was hard! I'm just going to copypaste the instructions in full:

>Given a number determine whether or not it is valid per the Luhn formula.
>
>The [Luhn algorithm](https://en.wikipedia.org/wiki/Luhn_algorithm) is a simple checksum formula used to validate a variety of identification numbers, such as credit card numbers and Canadian Social Insurance Numbers.
>
>Strings of length 1 or less are not valid. Spaces are allowed in the input, but they should be stripped before checking. All other non-digit characters are disallowed.
>
>Example 1: valid credit card number
>
>4539 1488 0343 6467
>
>The first step of the Luhn algorithm is to double every second digit, starting from the right. We will be doubling
>
>4\_3\_ 1\_8\_ 0\_4\_ 6\_6\_
>
>If doubling the number results in a number greater than 9 then subtract 9 from the product. The results of our doubling:
>
>8569 2478 0383 3437
>
>Then sum all of the digits:
>
>8+5+6+9+2+4+7+8+0+3+8+3+3+4+3+7 = 80
>
>If the sum is evenly divisible by 10, then the number is valid. This number is valid!

Here's what got me through the first eight tests:

```ruby
class Luhn
  def self.valid?(number)
    digits = number.gsub(/\D/, '').to_i.digits
    
    # Strings of length 1 or less are not valid.
    if digits.length <= 1
      false
    else
      # Double every second digit.
      doubled = digits.each_with_index.map do |digit, index|
        digit *= 2 if index.odd?
        # If doubling the number results in a number 
        # greater than 9 then subtract 9 from the product.
        digit -= 9 if digit > 9
        digit
      end
      # Then sum all of the digits.
      # If the sum is evenly divisible by 10, then the number is valid.
      doubled.sum % 10 == 0
    end
  end
end
```

It's probably worth pointing out that `#digits` reverses the order of numbers, satisfying the "starting from the right" constraint.

Here's the test where it all started to go wrong:

```ruby
  def test_valid_strings_with_a_non_digit_included_become_invalid
    refute Luhn.valid?("055a 444 285")
  end
```

I realized I'd jumped the gun in stripping all non-digit characters in that first line. In fact the instructions explicitly state to only strip spaces before checking. A lesson in humility and reading the instructions carefully.

No worries, let me just re-arrange a few things, do what the instructions actually say and strip spaces first, then disallow non-digits, shouldn't be too hard...

```ruby
  def self.valid?(number)
    # Spaces should be stripped before checking. 
    digits = number.gsub(/\s/, '').to_i.digits
    
    # Strings of length 1 or less are not valid.
    # All other non-digit characters are disallowed.
    if number.length <= 1 ||
        /\D/.match?(number)
      return false
    end

    # Double every second digit, starting from the right.
    doubled = digits.each_with_index.map do |digit, index|
      digit *= 2 if index.odd?
      # If doubling the number results in a number 
      # greater than 9 then subtract 9 from the product.
      digit -= 9 if digit > 9
      digit
    end
    # Then sum all of the digits.
    # If the sum is evenly divisible by 10, then the number is valid.
    doubled.sum % 10 == 0
  end
```

Suddenly I had two failing tests, and so began the regressions.

This bad boy was no longer green:

```ruby
  def test_a_valid_canadian_sin
    assert Luhn.valid?("055 444 285")
  end
```

It turns out I'd fallen victim to (what I imagine to be) one of the classic blunders. `#to_i` will ignore leading zeros since it makes no sense for an integer to have them, so `"055 444 285"` was being converted to `55444285`, a perfectly good integer but not a valid Canadian Social Insurance Number.

At this point I needed to go back and change how I was converting the input strings into arrays of integers. Actually I should have done this much earlier.

```ruby
class Luhn
  def self.valid?(input)
    stripped = input.gsub(/\s/, '')
    
    return false if stripped.length <= 1 || /\D/.match?(stripped)

    digits = stripped.chars.map(&:to_i).reverse

    doubled = digits.each_with_index.map do |digit, index|
      digit *= 2 if index.odd?
      digit -= 9 if digit > 9
      digit
    end

    doubled.sum % 10 == 0
  end
end
```

```ruby
class Luhn
  def self.valid?(input)
    stripped = input.gsub(/\s/, '')
    
    return false if stripped.length <= 1 || /\D/.match?(stripped)

    stripped.
      chars.
      map(&:to_i).
      reverse.
      each_with_index.
      map do |digit, index|
        digit *= 2 if index.odd?
        digit -= 9 if digit > 9
        digit
      end.
      sum % 10 == 0
  end
end
```

```ruby
class Luhn
  def self.valid?(input)
    stripped = input.gsub(/\s/, '')
    
    return false if stripped.length <= 1 || /\D/.match?(stripped)

    stripped
      .chars
      .map(&:to_i)
      .reverse
      .map.with_index { |d, i| i.odd? ? d * 2 : d }
      .map { |d| d > 9 ? d - 9 : d }
      .sum % 10 == 0
  end
end
```

```ruby
class Luhn
  def self.valid?(input)
    input
      .gsub(/\s/, '')
      .tap { |s| return false if s.length <= 1 || /\D/.match?(s) }
      .chars
      .map(&:to_i)
      .reverse
      .map.with_index { |d, i| i.odd? ? d * 2 : d }
      .map { |d| d > 9 ? d - 9 : d }
      .sum % 10 == 0
  end
end
```

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
