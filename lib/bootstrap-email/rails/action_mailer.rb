# frozen_string_literal: true

ActiveSupport.on_load(:action_mailer, { yield: true }) do |action_mailer|
  action_mailer.class_eval do # To support Rails less than 6
    # sit in the middle and compile the html
    def bootstrap_mail(*args, &block)
      mail_message = mail(*args, &block)
      BootstrapEmail::Rails::Hook.new(mail_message).perform if mail_message
      mail_message
    end
    alias_method :bootstrap_email, :bootstrap_mail
    alias_method :make_bootstrap_mail, :bootstrap_mail
  end
end
