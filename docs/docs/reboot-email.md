---
layout: docs
title:  "Reboot Email"
---
<h1 class="mt-0">{{ page.title }}</h1>

Similar to Bootstraps Reboot, Reboot Email set styles to try and normalize the differences between email clients so the base email is as consistent as possible. Here is the Reboot Email file which is influenced greatly by the [Mailchimp email reset](https://templates.mailchimp.com/development/css/reset-styles/).

```scss
body, .body{
  margin: 0;
  Margin: 0;
  padding: 0;
  border: 0;
  outline: 0;
  width: 100%;
  min-width: 100%;
  height: 100%;
  -webkit-text-size-adjust: 100%;
  -ms-text-size-adjust: 100%;
  font-family: $font-family-sans-serif;
  line-height: $line-height-base * $font-size-base;
  font-weight: normal;
  font-size: $font-size-base;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
}

img{
  border: 0 none;
  height: auto;
  line-height: 100%;
  outline: none;
  text-decoration: none;
}

a img{
  border: 0 none;
}

table{
  font-family: $font-family-sans-serif;
  mso-table-lspace: 0pt;
  mso-table-rspace: 0pt;
}

table, td{
  border-spacing: 0px;
  border-collapse: collapse;
}

th,
td,
p {
  line-height: $line-height-base * $font-size-base;
  font-size: $font-size-base;
  margin: 0;
}
```
