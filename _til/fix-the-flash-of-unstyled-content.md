---
layout: post
title: Fix the 'flash of unstyled content'
date: 2021-04-29 20:09 +1000
---

At the top of your HTML:

```html
<!doctype html>
<html>
<head>
    <style>html{visibility: hidden;opacity:0;}</style>
```

At the end of your last .css file:

```css
html {
    visibility: visible;
    opacity: 1;
}
```

([via electrotype](https://gist.github.com/electrotype/7960ddcc44bc4aea07a35603d1c41cb0))
