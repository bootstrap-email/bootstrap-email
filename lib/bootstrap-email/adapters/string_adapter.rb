module BootstrapEmail
  class StringAdapter
    CORE_SCSS_PATH = File.expand_path('../../../core/bootstrap-email.scss', __dir__)
    attr_accessor :doc

    def initialize(string)
      SassC.load_paths << File.expand_path('../../../core', __dir__)
      @premailer = Premailer.new(
        string,
        with_html_string: true,
        preserve_reset: false,
        css_string: BootstrapEmail::SassCache.compile(CORE_SCSS_PATH, style: :expanded)
      )
      self.doc = @premailer.doc
    end

    def inline_css!
      @premailer.to_inline_css
    end

    def finalize_document!
      @doc.to_html
    end
  end
end
