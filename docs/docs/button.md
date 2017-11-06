---
layout: docs
title:  "Button"
themeable: true
responsive: false
---
{% include doc-header.html %}

Use a button on an anchor tag to link out of an email.

<div class="alert alert-info">
  <strong>Note:</strong> Only to be used with anchor `&lt;a&gt;` tag.
</div>

```html
<a class="btn btn-primary" href="https://bootstrapemail.com">Primary</a>
<a class="btn btn-secondary" href="https://bootstrapemail.com">Secondary</a>
<a class="btn btn-success" href="https://bootstrapemail.com">Success</a>
<a class="btn btn-danger" href="https://bootstrapemail.com">Danger</a>
<a class="btn btn-warning" href="https://bootstrapemail.com">Warning</a>
<a class="btn btn-info" href="https://bootstrapemail.com">Info</a>
<a class="btn btn-light" href="https://bootstrapemail.com">Light</a>
<a class="btn btn-dark" href="https://bootstrapemail.com">Dark</a>
```

<a href="#" class="btn btn-primary">Primary</a>
<a href="#" class="btn btn-secondary">Secondary</a>
<a href="#" class="btn btn-success">Success</a>
<a href="#" class="btn btn-danger">Danger</a>
<a href="#" class="btn btn-warning">Warning</a>
<a href="#" class="btn btn-info">Info</a>
<a href="#" class="btn btn-light">Light</a>
<a href="#" class="btn btn-dark">Dark</a>

<div class="alert alert-warning">
  <strong>Warning:</strong> You must supply a url in the href. Using just pound sign is not enough for some emails to render an anchor tag correctly.
</div>

### Sizes
```html
<a class="btn btn-primary btn-lg" href="https://bootstrapemail.com">Large button</a>
<a class="btn btn-secondary btn-lg" href="https://bootstrapemail.com">Large button</a>
```

<a href="#" class="btn btn-primary btn-lg">Large button</a>
<a href="#" class="btn btn-secondary btn-lg">Large button</a>
