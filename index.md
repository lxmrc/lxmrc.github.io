---
layout: page
title: home
---

<ul class="posts">
  {% for post in site.posts %}
    <li>
       {% include post_link.html %}
    </li>
  {% endfor %}
</ul>
