# frozen_string_literal: true

ActiveSupport.on_load(:action_mailer, { yield: true }) do |action_mailer|
  action_mailer.class_eval do # To support Rails less than 6
    # Only override mail method if override_mail_method is enabled
    if BootstrapEmail.static_config.override_mail_method
      alias_method :rails_mail, :mail unless method_defined?(:rails_mail)
      def mail(*args, &block)
        bootstrap_mail(*args, &block)
      end
    end

    def bootstrap_mail(*args, &block)
      message = respond_to?(:rails_mail) ? rails_mail(*args, &block) : mail(*args, &block)
      BootstrapEmail::Rails::MailBuilder.perform(message)
    end
    alias_method :bootstrap_email, :bootstrap_mail
    alias_method :make_bootstrap_mail, :bootstrap_mail
  end
end
