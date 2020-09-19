module BootstrapEmail
  module StringAndFileCompiler
    def setup(string: nil, file: nil)
      @mail = mail
      @source = mail.html_part || mail
      update_doc(@source.body.raw_source)
    end

    def set_premailer_document(path_or_html, with_html_string:)
      SassC.load_paths << File.expand_path('../core', __dir__)
      @premailer = Premailer.new(
        path_or_html,
        with_html_string: with_html_string,
        css_string: SassC::Engine.new(File.read(CORE_SCSS_PATH), syntax: :scss, style: :compressed, cache: true, read_cache: true).render
      )
      @doc = @premailer.doc
    end
  end
end
