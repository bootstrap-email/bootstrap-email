require 'nokogiri'
require 'erb'
require 'ostruct'
require 'premailer'
require 'sassc'

if defined?(Rails)
  require 'rails'
  require 'action_mailer'
  require 'premailer/rails'
end

require_relative 'bootstrap-email/adapters/rails_adapter'
require_relative 'bootstrap-email/adapters/string_and_file_adapter'
require_relative 'bootstrap-email/compiler'
require_relative 'bootstrap-email/version'

if defined?(Rails)
  require_relative 'bootstrap-email/rails/premailer_railtie'
  require_relative 'bootstrap-email/rails/action_mailer'
  require_relative 'bootstrap-email/rails/engine'
end
