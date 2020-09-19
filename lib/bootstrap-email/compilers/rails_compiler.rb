module BootstrapEmail
  module RailsCompiler
    def setup(mail)
      @mail = mail
      @source = mail.html_part || mail
      update_doc(@source.body.raw_source)
    end
  end
end
