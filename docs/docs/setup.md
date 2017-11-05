---
layout: docs
title:  "Setup"
---

# Setup

### Current Environment Support
- Ruby on Rails

### Future Support (Help Wanted <3)
- General Ruby Support
- General PHP Support
- Laravel Support
- Node/JS Support

___

### Rails Setup

Setup with Rails could not be easier.

1: Add Bootstrap Email to your `Gemfile`

```
gem 'bootstrap-email'
```

2: Create a new file `/app/views/layouts/bootstrap-mailer.html.erb` and paste this HTML into it. (It is very similar to the default one.)

```erb
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%= bootstrap_email_head %>
    <%= stylesheet_link_tag "application-mailer", media: "all" %>
  </head>
  <body class="bg-light">
    <%= yield %>
  </body>
</html>
```

3: Create a new stylesheet `/app/assets/stylesheets/application-mailer.scss` and import `bootstrap-email`. This is where your custom styles and overrides that you want to be inlined should live.

```sass
@import 'bootstrap-email'
```

4: Add this line in `/config/initializers/asset.rb` to compile your new SASS file.

```ruby
Rails.application.config.assets.precompile += %w( application-mailer.scss )
```

#### Usage
Thats it! Now all you need to do to use it instead of using the `mail()` method, you use the `bootstrap_mail()` method to kick off Bootstrap Email compilation!

```ruby
class ExampleMailer < ApplicationMailer

  def show
    bootstrap_mail(
      to: 'to@example.com',
      from: 'from@example.com',
      subject: 'Hi From Bootstrap Email',
    )
  end
end
```
