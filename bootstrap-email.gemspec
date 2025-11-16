# frozen_string_literal: true

require_relative 'lib/bootstrap-email/version'

Gem::Specification.new do |s|
  s.name        = 'bootstrap-email'
  s.version     = BootstrapEmail::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'Bootstrap 5+ stylesheet, compiler, and inliner for responsive and consistent emails with the Bootstrap syntax you know and love. Support: command line, ruby, rails'
  s.authors     = ['Stuart Yamartino']
  s.email       = 'stu@stuyam.com'
  s.files       = Dir['lib/**/*'] + Dir['core/**/*'] + ['VERSION']
  s.homepage    = 'https://bootstrapemail.com'
  s.license     = 'MIT'

  s.executables << 'bootstrap-email'

  s.add_runtime_dependency 'htmlbeautifier', '~> 1.3'
  s.add_runtime_dependency 'nokogiri', '~> 1.6'
  s.add_runtime_dependency 'premailer', '~> 1.7'
  s.add_runtime_dependency 'sass-embedded', '~> 1.55'
  s.add_runtime_dependency 'ostruct', '~> 0.6'

  s.required_ruby_version = '>= 2.0'
  s.metadata['rubygems_mfa_required'] = 'true'
end
