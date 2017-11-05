---
layout: docs
title:  "Preview Text"
---
# Preview Text

If you aren't familiar with preview text, it is the text that shows up in your inbox as a preview of the content inside the email. Here is more info about what it is and how it works on [Litmus.com](https://litmus.com/blog/the-ultimate-guide-to-preview-text-support)
<img class="d-block mx-auto w-50" src="https://d31v04zdn5vmni.cloudfront.net/blog/wp-content/uploads/2015/04/ios-gmail-app-preview-text.jpg" />

Bootstrap Email has a custom `<preview>` tag you can use to define preview text in your emails. This way it will show up as a preview of your email in your inbox but will be completely hidden when viewing the email itself.

```html
<preview>This text will show up as a preview but not in the email!</preview>
```
