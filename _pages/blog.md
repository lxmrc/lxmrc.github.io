---
layout: page-no-anchor
title: Blog
permalink: /blog
---

## All Blog Posts (`ORDER BY date_published DESC`)
{% for post in site.posts %}
  * [ {{ post.title }} ]({{ post.url }}) <time class="archive-date">{{ post.date | date: '%b %Y' }}</time>

{% endfor %}
