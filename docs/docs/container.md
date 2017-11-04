---
layout: docs
title:  "Container"
themeable: false
responsive: true
---
{% include doc-header.html %}

Wrap you page content in a container to bring the content in tighter and center align in the page. The max-width on the container is 600px which is the standard width for emails. It will be responsive on mobile devices.

### Container
{% highlight html %}
<div class="container">
  <!-- Content here -->
</div>
{% endhighlight %}

<div class="container">
  <!-- Content here -->
</div>

### Container fluid

A fluid container is unlike a container in that it doesn't have it's max-width set. It does however still have padding on the edges to make the content bad better space towards the edge of the email.

{% highlight html %}
<div class="container-fluid">
  <!-- Content here -->
</div>
{% endhighlight %}

<div class="container-fluid">
  <!-- Content here -->
</div>
