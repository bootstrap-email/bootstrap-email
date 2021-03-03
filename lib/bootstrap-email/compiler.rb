module BootstrapEmail
  class Compiler
    attr_accessor :type, :doc, :premailer

    def initialize(input, type: :string, options: {})
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
      build_premailer_doc(html, options)
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

    def build_premailer_doc(html, options)
      SassC.load_paths << File.expand_path('../../core', __dir__)
      css_string = BootstrapEmail::SassCache.compile('bootstrap-email', config_path: options[:config_path], style: :expanded)
      self.premailer = Premailer.new(
        html,
        with_html_string: true,
        preserve_reset: false,
        css_string: css_string
      )
      self.doc = premailer.doc
    end

    def compile_html!
      BootstrapEmail::Component::Button.build(doc)
      BootstrapEmail::Component::Badge.build(doc)
      BootstrapEmail::Component::Alert.build(doc)
      BootstrapEmail::Component::Card.build(doc)
      BootstrapEmail::Component::Paragraph.build(doc)
      BootstrapEmail::Component::Hr.build(doc)
      BootstrapEmail::Component::Container.build(doc)
      BootstrapEmail::Component::Grid.build(doc)
      BootstrapEmail::Component::Align.build(doc)
      BootstrapEmail::Component::Spacing.build(doc)
      BootstrapEmail::Component::Padding.build(doc)
      BootstrapEmail::Component::Margin.build(doc)
      BootstrapEmail::Component::Spacer.build(doc)
      BootstrapEmail::Component::Table.build(doc)
      BootstrapEmail::Component::Block.build(doc)
      BootstrapEmail::Component::Body.build(doc)
      BootstrapEmail::Component::PreviewText.build(doc)
    end

    def inline_css!
      premailer.to_inline_css
    end

    def configure_html!
      BootstrapEmail::Component::ForceEncoding.build(doc)
      BootstrapEmail::Component::HeadStyle.build(doc)
      BootstrapEmail::Component::VersionComment.build(doc)
    end

    def finalize_document!
      html = BootstrapEmail::Component::ForceEncoding.replace(doc.to_html)
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
