---
layout: docs
title:  "Button"
themeable: true
responsive: false
---
{% include doc-header.html %}

Use a button on an anchor tag to link out of an email.

<div class="alert alert-info">
  <strong>Note:</strong> Only to be used with anchor <code>&lt;a&gt;</code> tag.
</div>

{% highlight html %}
<a href="https://bootstrapemail.com" class="btn btn-primary">Primary</a>
<a href="https://bootstrapemail.com" class="btn btn-secondary">Secondary</a>
<a href="https://bootstrapemail.com" class="btn btn-success">Success</a>
<a href="https://bootstrapemail.com" class="btn btn-danger">Danger</a>
<a href="https://bootstrapemail.com" class="btn btn-warning">Warning</a>
<a href="https://bootstrapemail.com" class="btn btn-info">Info</a>
<a href="https://bootstrapemail.com" class="btn btn-light">Light</a>
<a href="https://bootstrapemail.com" class="btn btn-dark">Dark</a>
{% endhighlight %}

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

## Sizes
{% highlight html %}
<a href="https://bootstrapemail.com" class="btn btn-primary btn-lg">Large button</a>
<a href="https://bootstrapemail.com" class="btn btn-secondary btn-lg">Large button</a>
{% endhighlight %}

<a href="#" class="btn btn-primary btn-lg">Large button</a>
<a href="#" class="btn btn-secondary btn-lg">Large button</a>
