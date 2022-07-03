# frozen_string_literal: true

ActiveSupport.on_load(:action_mailer, { yield: true }) do |action_mailer|
  action_mailer.class_eval do # To support Rails less than 6
    def bootstrap_mail(*args, &block)
      message = mail(*args, &block)
      BootstrapEmail::Rails::MailBuilder.perform(message)
    end
    alias_method :bootstrap_email, :bootstrap_mail
    alias_method :make_bootstrap_mail, :bootstrap_mail
  end
end
