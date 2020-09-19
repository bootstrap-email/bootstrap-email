module BootstrapEmail
  module RailsAdapter
    attr_reader :doc

    def initialize(mail)
      @mail = mail
      @source = mail.html_part || mail
      self.doc = @source.body.raw_source
    end

    def doc=(source)
      @doc = Nokogiri::HTML(source)
    end

    def inline_css!
      @source.body = doc.to_html
      @mail = Premailer::Rails::Hook.perform(@mail)
      @mail.header[:skip_premailer] = true
      self.doc = @mail.html_part.body.raw_source)
    end

    def finalize_document!
      @mail.html_part.body = doc.to_html
      @mail
    end
  end
end
