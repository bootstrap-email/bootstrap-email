source 'https://rubygems.org'

gemspec
gem 'rspec'
gem 'byebug'

rails_version = ENV.fetch('ACTION_MAILER_VERSION', '6')
if rails_version == 'master'
  git 'git://github.com/rails/rails.git' do
    gem 'rails'
  end
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
  gem 'arel', github: 'rails/arel'
else
  gem 'rails', "~> #{rails_version}"
end
