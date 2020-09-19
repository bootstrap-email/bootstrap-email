module BootstrapEmail
  module StringAndFileAdapter
    CORE_SCSS_PATH = File.expand_path('../../../core/bootstrap-email.scss', __dir__)
    attr_accessor :doc

    def initialize(string_or_file, with_html_string:)
      SassC.load_paths << File.expand_path('../../../core', __dir__)
      @premailer = Premailer.new(
        string_or_file,
        with_html_string: with_html_string,
        css_string: SassC::Engine.new(File.read(CORE_SCSS_PATH), syntax: :scss, style: :compressed, cache: true, read_cache: true).render
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
