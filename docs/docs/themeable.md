---
layout: docs
title:  "Themeable"
---
# {{ page.title }}

When you see the
<span class="d-inline-block">
  <a href="/docs/themeable" class="badge m-0 d-flex align-items-center compatability-badge">
    <span class="badge-check">
      <img src="/img/icons/check.svg" />
    </span>
    <span>Themeable</span>
  </a>
</span> badge it means the component has the following classes that you can use color the component. Just like Bootstrap, the convention is <code>{component}-{theme-color}<code>.

{% highlight html %}
{component}-primary
{component}-secondary
{component}-success
{component}-danger
{component}-warning
{component}-info
{component}-light
{component}-dark
{% endhighlight %}

Bootstrap Email uses the same default color scheme that Bootstrap 4 does.
<div class="themable-example text-white bg-primary">primary</div>
<div class="themable-example text-white bg-secondary">secondary</div>
<div class="themable-example text-white bg-success">success</div>
<div class="themable-example text-white bg-danger">danger</div>
<div class="themable-example bg-warning">warning</div>
<div class="themable-example text-white bg-info">info</div>
<div class="themable-example bg-light">light</div>
<div class="themable-example text-white bg-dark">dark</div>
<div class="themable-example bg-white">white</div>

<style>
  .themable-example{
    width: 100px;
    height: 100px;
    border-radius: 10px;
    display: inline-block;
    margin: 0 1rem 1rem 0;
    padding: 2.25rem 0;
    text-align: center;
  }
</style>
