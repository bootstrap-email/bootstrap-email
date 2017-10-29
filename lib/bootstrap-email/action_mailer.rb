class ActionMailer::Base
  helper BootstrapEmailHelper

  def bootstrap_mail *args
    mail = mail(*args)
    bootstrap = BootstrapEmail.new(mail)
    bootstrap.compiled_html!
  end
end

module BootstrapEmailHelper

  def bootstrap_email_head
    <<-HEREDOC
      <style>
        #{File.open('../../core/sass/head.scss').read}
      </style>
    HEREDOC
  end
end
