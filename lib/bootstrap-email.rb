require 'nokogiri'
require 'erb'
require 'ostruct'
require 'active-mailer'
require 'premailer'

Premailer::Rails.config.merge!(adapter: :nokogiri)


require 'bootstrap-email/bootstrap-email'
require 'bootstrap-email/active-mailer'
require 'bootstrap-email/engine'
require 'bootstrap-email/version'
