ActiveSupport.on_load(:action_mailer, { yield: true }) do |action_mailer|
  action_mailer.class_eval do # To support Rails less than 6
    # sit in the middle and compile the html
    def bootstrap_mail(*args, &block)
      mail_message = mail(*args, &block)
      # if you override the #mail method in you ApplicationMailer you may intentionally return something other than a mail message
      if mail_message
        bootstrap = BootstrapEmail::Compiler.new(mail_message, type: :rails)
        bootstrap.perform_full_compile
      end
      mail_message
    end
    alias_method :bootstrap_email, :bootstrap_mail
    alias_method :make_bootstrap_mail, :bootstrap_mail
  end
end
