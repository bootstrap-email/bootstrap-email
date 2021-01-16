require 'rspec'
require 'byebug'

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
require File.expand_path('rails_app/config/environment.rb', __dir__)

require_relative '../lib/bootstrap_email'
