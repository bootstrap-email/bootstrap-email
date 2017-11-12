---
layout: docs
title:  "Images"
themeable: false
responsive: true
---
{% include doc-header.html %}

Images can be very complicated in emails. Luckily Bootstrap email makes it easy.

<strong>Note: All images must have a `height` and `width` property on the image to size it correctly in Outlook.</strong>

To keep an element full width of it's container, give it the `img-fluid` class and make sure apply the width and height properties as always to make sure it fits in Outlook.

```html
<img class="img-fluid" width="600" height="250" src="https://bootstrapemail.com/some/image.png" alt="Some Image" />
```
