---
layout: page
title: Today I Learned
permalink: /til
---

## Today I Learned notes

Don't you just love researching how to solve a problem and then running into it again 3 weeks later and researching it all over again?

This is where I write down stuff I learn in case I need it later. Inspired by [Hashrocket’s TIL](https://til.hashrocket.com).

---

<ul class="posts til">
  {% for post in site.posts %}
    {% if post.tags contains "til" %}
      <li>
        <a class="post" href="{{ post.url }}">{{ post.title }}</a>
        <time class="archive-date">{{ post.date | date: site.date_format }}</time>
      </li>
    {% endif %}
  {% endfor %}
</ul>
