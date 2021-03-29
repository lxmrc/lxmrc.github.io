---
layout: page
title: Today I Learned
permalink: /til
---

## TIL

Short for "today I learned". This is where I write stuff down for when I forget it later.

---

<ul class="posts til">
  {% assign posts = site.til | reverse %}
  {% for post in posts %}
      <li>
        <a class="post" href="{{ post.url }}">{{ post.title }}</a>
        <time class="archive-date">{{ post.date | date: site.date_format }}</time>
      </li>
  {% endfor %}
</ul>
