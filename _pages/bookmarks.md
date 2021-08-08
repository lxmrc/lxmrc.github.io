---
layout: page
title: Bookmarks
permalink: /bookmarks
---

## Bookmarks

---

<ul class="posts til">
  {% assign links = site.data.bookmarks | reverse %}
  {% for link in links %}
      <li>
        <a class="post" href="{{ link.url }}">{{ link.name }}</a>
      </li>
  {% endfor %}
</ul>
