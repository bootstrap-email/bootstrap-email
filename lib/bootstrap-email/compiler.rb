module BootstrapEmail
  class Compiler
    attr_accessor :type, :doc, :premailer

    def initialize(input, type: :string, options: {})
      BootstrapEmail.load_options(options)
      self.type = type
      case type
      when :rails
        @mail = input
        html = (@mail.html_part || @mail).body.raw_source
      when :string
        html = input
      when :file
        html = File.read(input)
      end
      html = add_layout!(html)
      sass_load_paths
      build_premailer_doc(html)
    end

    def perform_full_compile
      compile_html!
      inline_css!
      configure_html!
      finalize_document!
    end

    private

    def add_layout!(html)
      document = Nokogiri::HTML(html)
      return html unless document.at_css('head').nil?

      BootstrapEmail::Erb.template(
        File.expand_path('../../core/layout.html.erb', __dir__),
        contents: html
      )
    end

    def sass_load_paths
      SassC.load_paths << BootstrapEmail.config.sass_load_paths
    end

    def build_premailer_doc(html)
      css_string = BootstrapEmail::SassCache.compile('bootstrap-email', style: :expanded)
      self.premailer = Premailer.new(
        html,
        with_html_string: true,
        preserve_reset: false,
        adapter: :nokogiri_fast,
        output_encoding: 'US-ASCII',
        css_string: css_string
      )
      self.doc = premailer.doc
    end

    def compile_html!
      BootstrapEmail::Converter::Body.build(doc)
      BootstrapEmail::Converter::Block.build(doc)

      BootstrapEmail::Converter::Button.build(doc)
      BootstrapEmail::Converter::Badge.build(doc)
      BootstrapEmail::Converter::Alert.build(doc)
      BootstrapEmail::Converter::Card.build(doc)
      BootstrapEmail::Converter::Hr.build(doc)
      BootstrapEmail::Converter::Container.build(doc)
      BootstrapEmail::Converter::Grid.build(doc)
      BootstrapEmail::Converter::Stack.build(doc)

      BootstrapEmail::Converter::Color.build(doc)
      BootstrapEmail::Converter::Spacing.build(doc)
      BootstrapEmail::Converter::Margin.build(doc)
      BootstrapEmail::Converter::Spacer.build(doc)
      BootstrapEmail::Converter::Align.build(doc)
      BootstrapEmail::Converter::Padding.build(doc)

      BootstrapEmail::Converter::PreviewText.build(doc)
      BootstrapEmail::Converter::Table.build(doc)
    end

    def inline_css!
      premailer.to_inline_css
    end

    def configure_html!
      BootstrapEmail::Converter::HeadStyle.build(doc)
      BootstrapEmail::Converter::VersionComment.build(doc)
    end

    def finalize_document!
      html = doc.to_html(encoding: 'US-ASCII')
      BootstrapEmail::Converter::SupportUrlTokens.replace(html)
      BootstrapEmail::Converter::ForceEncoding.replace(html)
      BootstrapEmail::Converter::BeautifyHTML.replace(html)
      case type
      when :rails
        (@mail.html_part || @mail).body = html
        @mail
      when :string, :file
        html
      end
    end
  end
end
