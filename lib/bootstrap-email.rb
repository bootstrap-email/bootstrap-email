# frozen_string_literal: true

require 'nokogiri'
require 'erb'
require 'ostruct'
require 'premailer'
require 'sass-embedded'
require 'digest/sha1'
require 'css_parser'
require 'fileutils'
require 'htmlbeautifier'

begin
  require 'rails'
rescue LoadError; end

require 'action_mailer' if defined?(Rails)

require_relative 'bootstrap-email/config_store'
require_relative 'bootstrap-email/config'
require_relative 'bootstrap-email/setup'
require_relative 'bootstrap-email/erb'
require_relative 'bootstrap-email/compiler'
require_relative 'bootstrap-email/sass_cache'
require_relative 'bootstrap-email/version'
require_relative 'bootstrap-email/converters/base'
Dir[File.join(__dir__, 'bootstrap-email/converters', '*.rb')].each { |file| require_relative file }

if defined?(Rails)
  require_relative 'bootstrap-email/rails/action_mailer'
  require_relative 'bootstrap-email/rails/engine'
  require_relative 'bootstrap-email/rails/mail_builder'
end
