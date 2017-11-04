---
layout: docs
title:  "Spacing"
themeable: false
responsive: false
---
{% include doc-header.html %}

There is two types of spacing Bootstrap Email supports. Padding (applied to the inside of table cells) and Margin (in the form of vertical spacers).
Just like Bootstrap there are the `.p{side}-{size}`and similarly for margin helpers.

List of supported classes:
```css
.p-{0-5}  /* padding on all sides */
.pt-{0-5} /* padding top */
.pr-{0-5} /* padding right */
.pb-{0-5} /* padding bottom */
.pl-{0-5} /* padding left */
.px-{0-5} /* padding left and right */
.py-{0-5} /* padding top and bottom */

.mt-{0-5} /* margin top */
.mb-{0-5} /* margin bottom */
.my-{0-5} /* margin top and bottom */

.s-{0-5} /* spacer with size */
```

Note: Margin is only supported on the top and bottom.

### Padding
```html
<a class="btn btn-primary p-3" href="http://bootstrapemail.com">A Button with lots of padding</a>
```

<a class="btn btn-primary p-3" href="http://bootstrapemail.com">A Button with lots of padding</a>

### Margin
The margin classes just create spacers above and/or below and element for simpler syntax like Bootstrap.
```html
<div class="card card-body">Top Card</div>
<div class="card card-body my-3">Middle Card (with margin above and below)</div>
<div class="card card-body">Bottom Card</div>
```

<div class="card card-body">Top Card</div>
<div class="card card-body my-3">Middle Card (with margin about and below)</div>
<div class="card card-body">Bottom Card</div>

### Spacer
```html
<div class="s-3"></div>
```

Spacers hold not content, they are just put into the document to sit between elements in a vertical flow.
