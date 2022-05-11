# frozen_string_literal: true

source 'https://rubygems.org'

gemspec
gem 'byebug', require: true
gem 'rspec'
gem 'rubocop'

rails_version = ENV.fetch('ACTION_MAILER_VERSION', '6')
if rails_version == 'master'
  git 'git://github.com/rails/rails.git' do
    gem 'rails'
  end
  gem 'arel', github: 'rails/arel'
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
else
  gem 'rails', "~> #{rails_version}"
end
