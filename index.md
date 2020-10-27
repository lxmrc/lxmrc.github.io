---
layout: page
title: Home
---

Hi, I'm Alex. I'm a Ruby developer based in Melbourne, Australia. This is where I blog about computers.

### Recent posts

---
<ul class="posts">
  {% for post in site.posts %}
    <li>
       {% include post_link.html %}
    </li>
  {% endfor %}
</ul>
