require 'nokogiri'
require 'erb'
require 'ostruct'
require 'premailer'
require 'sassc'
require 'digest/sha1'
require 'css_parser'

begin
  require 'rails'
rescue LoadError; end

if defined?(Rails)
  require 'action_mailer'
end

require_relative 'bootstrap-email/initialize'
require_relative 'bootstrap-email/compiler'
require_relative 'bootstrap-email/sass_cache'
require_relative 'bootstrap-email/version'
require_relative 'bootstrap-email/components/base'
Dir[File.join(__dir__, 'bootstrap-email/components', '*.rb')].each { |file| require_relative file }

if defined?(Rails)
  require_relative 'bootstrap-email/rails/action_mailer'
  require_relative 'bootstrap-email/rails/engine'
end
