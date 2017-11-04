---
layout: docs
title:  "Grid"
themeable: false
responsive: true
---
{% include doc-header.html %}

Grids work just like they do in Bootstrap, based on a 12 column grid. Make a row and give it columns. By default the grid holds it's structure on every device.

{% highlight html %}
<div class="row">
  <div class="col-3">.col-3</div>
  <div class="col-4">.col-4</div>
  <div class="col-5">.col-5</div>
</div>
{% endhighlight %}

<div class="row mb-4">
  <div class="col-3 border">.col-3</div>
  <div class="col-4 border">.col-4</div>
  <div class="col-5 border">.col-5</div>
</div>
#### Responsive
You can use the responsive <code>lg</code> modifier to make the grid snap back to vertical stacking on smaller devices.

{% highlight html %}
<div class="row">
  <div class="col-lg-3">.col-3</div>
  <div class="col-lg-4">.col-4</div>
  <div class="col-lg-5">.col-5</div>
</div>
{% endhighlight %}

<div class="row">
  <div class="col-lg-3 border">.col-3</div>
  <div class="col-lg-4 border">.col-4</div>
  <div class="col-lg-5 border">.col-5</div>
</div>
