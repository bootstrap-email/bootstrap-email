---
layout: docs
title:  "Setup"
---
<h1 class="mt-0">{{ page.title }}</h1>

### Current Environment Support
- Ruby on Rails
- [Online editor](https://bootstrapemail.com/editor)

### Future Support (Help Wanted <3)
- Node/JS Support
- General Ruby Support
- General PHP Support
- Laravel Support

I am thinking of building the render in Node and then running in a ruby / php runtime to compile. Looking for feedback here, let me know.

___

### Rails Setup

Setup with Rails could not be easier.

1: Add Bootstrap Email to your `Gemfile`

```
gem 'bootstrap-email'
```

2: Create a new file `/app/views/layouts/example_mailer.html.erb` and paste this HTML into it. (It is very similar to the default one).

The name of this file follows the rules of ActionMailer, that loads a layout deriving the name from the mailer class name.
If you want a different behaviour, such as using the same template for all the mailers, or specifying a template for a single method, refer to the [official ActionMailer documentation](http://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-layouts).

```erb
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%= stylesheet_link_tag "application-mailer", media: "all" %>
  </head>
  <body class="bg-light">
    <%= yield %>
  </body>
</html>
```

3: Create a new stylesheet `/app/assets/stylesheets/application-mailer.scss` and import `bootstrap-email`. This is where your custom styles and overrides that you want to be inlined should live.

```sass
@import 'bootstrap-email';
```

4: Add this line in `/config/initializers/asset.rb` to compile your new SASS file.

```ruby
Rails.application.config.assets.precompile += %w( application-mailer.scss )
```

5: Create the view file `/app/views/example_mailer/greet.html.erb`.

You can also create the view `/app/views/example_mailer/greet.text.erb`. In this case don't forget to create also the textual layout `/app/views/layouts/example_mailer.text.erb`.

If you do  not create a textual view file, a text part is automatically added by the `premailer-rails` gem.

### Usage
Thats it! Now all you need to do to use it instead of using the `mail()` method, you use the `make_bootstrap_mail()` method to kick off Bootstrap Email compilation!

```ruby
class ExampleMailer < ApplicationMailer

  def greet
    make_bootstrap_mail(
      to: 'to@example.com',
      from: 'from@example.com',
      subject: 'Hi From Bootstrap Email',
    )
  end
end
```

You can also use the `format` in the usual way.
```ruby
class ExampleMailer < ApplicationMailer

  def greet
    make_bootstrap_mail(
      to: 'to@example.com',
      from: 'from@example.com',
      subject: 'Hi From Bootstrap Email',
      ) do |format|
        format.html { layout 'custom_bootstrap_layout' }
        format.text # here example_mailer.text.erb is used
      end
  end
end
```

### Compatibility note
The old method `bootstrap_mail` is still available for compatibility.
