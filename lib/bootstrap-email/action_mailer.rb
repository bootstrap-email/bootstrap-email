module BootstrapEmailHelper

  def bootstrap_email_head
    html_string = <<-HEREDOC
      <style type="text/css" data-premailer="ignore">
        #{File.open(File.expand_path('../../core/sass/head.scss', __dir__)).read}
      </style>
    HEREDOC
    html_string.html_safe
  end
end

class ActionMailer::Base
  helper BootstrapEmailHelper

  def bootstrap_mail *args
    mail = mail(*args)
    BootstrapEmail.compile_html!(mail)
  end
end
