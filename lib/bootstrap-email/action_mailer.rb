class ActionMailer::Base

  # sit in the middle and compile the html
  def bootstrap_mail *args
    bootstrap = BootstrapEmail::Compiler.new(mail(*args))
    bootstrap.compile_html!
    bootstrap.update_mailer!
  end

  # helper to inject style tags into head of the email template
  module BootstrapEmailHelper
    def bootstrap_email_head
      html_string = <<-HEREDOC
        <style type="text/css" data-premailer="ignore">
          #{File.open(File.expand_path('../../core/head.css', __dir__)).read}
        </style>
      HEREDOC
      html_string.html_safe
    end
  end
  helper BootstrapEmailHelper
end
