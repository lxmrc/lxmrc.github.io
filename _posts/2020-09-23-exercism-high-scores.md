---
layout: post
title: 'Exercism: High Scores'
date: 2020-09-23 12:23 +1000
tag: exercism
---

>Your task is to build a high-score component of the classic Frogger game, one of the highest selling and addictive games of all time, and a classic of the arcade era.<!--more--> Your task is to write methods that return the highest score from the list, the last added score and the three highest scores.

<!--description-->

We can get the first four tests passing by hard-coding the correct output, which is stupid, but is also following strict TDD:

```ruby
class HighScores
  def initialize(scores)
  end

  def scores
    [30, 50, 20, 70]
  end

  def latest
    30
  end

  def personal_best
    100
  end

  def personal_top_three
    [100, 90, 70]
  end
end
```

The fifth test forces us to actually start implementing some logic, but not that much:

```ruby
class HighScores
  attr_reader :scores

  def initialize(scores)
    @scores = scores
  end

  def latest
    30
  end

  def personal_best
    100
  end

  def personal_top_three
    scores.max(3)
  end
end
```

In fact it's not until the last test that we're forced to actually implement every method correctly:

```ruby
class HighScores
  attr_reader :scores

  def initialize(scores)
    @scores = scores
  end

  def latest
    scores.last
  end

  def personal_best
    scores.max
  end

  def personal_top_three
    scores.max(3)
  end

  def latest_is_personal_best?
    latest == personal_best
  end
end
```

Upon looking through some of the highly-starred solutions it occurs to me that you could make the first four methods into attribute readers and save a lot of space:

```ruby
class HighScores
  attr_reader :scores, :latest, :personal_best, :personal_top_three

  def initialize(scores)
    @scores = scores
    @latest = scores.last
    @personal_best = scores.max
    @personal_top_three = scores.max(3)
  end
  
  def latest_is_personal_best?
    latest == personal_best
  end
end
```
Join me next time for another exciting exercism.
