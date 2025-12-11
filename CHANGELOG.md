# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.8.0] - 2025-12-11

### Added
- Support for overriding the mail method in Rails via `override_mail_method` configuration option.
- This will likely be the default in 2.0
- This will make emails _just work_ with Devise, just need to add `config.parent_mailer = "ApplicationMailer"` to Devise config to use default layout.
- Example rails config:
```ruby
# config/initializers/bootstrap_email.rb
BootstrapEmail.configure do |config|
  config.override_mail_method = true
end
```
