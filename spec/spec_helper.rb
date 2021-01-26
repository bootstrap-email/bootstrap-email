require 'rspec'
require 'byebug'
require_relative '../lib/bootstrap_email'

# Configure Rails Environment
if defined?(Rails)
  ENV['RAILS_ENV'] = 'test'
  require File.expand_path('rails_app/config/environment.rb', __dir__)
end

RSpec.configure do |config|
  config.after(:suite) do
    Dir.glob('spec/html/output/*', base: Dir.pwd).each do |file|
      File.delete(file)
    end
  end
end
