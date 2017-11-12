---
layout: docs
title:  "Body"
---
<h1 class="mt-0">{{ page.title }}</h1>

A table with the class `.body` automatically wraps the email content and applies styles to give more consistent layout to the page. You can put classes on the `<body>` that will be moved onto the body table.

For example this:
```html
...
<body class="bg-light">
  ...
</body>
```

Becomes this:
```html
...
<body>
  <table class="body bg-light">
    ...
  </table>
</body>
```
