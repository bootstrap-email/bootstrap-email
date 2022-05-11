# frozen_string_literal: true

class WelcomeMailer < ApplicationMailer
  def welcome_email(greeting)
    @greeting = greeting
    bootstrap_mail to: 'example@example.com'
  end
end
