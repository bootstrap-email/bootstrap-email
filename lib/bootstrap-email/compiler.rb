# frozen_string_literal: true

module BootstrapEmail
  class Compiler
    attr_accessor :type, :config, :doc, :premailer

    def initialize(input, type: :string, options: {})
      self.config = BootstrapEmail::Config.new(options)
      self.type = type
      case type
      when :string
        html = input
      when :file
        html = File.read(input)
      end
      html = add_layout(html)
      build_premailer_doc(html)
    end

    def perform_multipart_compile
      @perform_multipart_compile ||= {
        text: perform_text_compile,
        html: perform_html_compile
      }
    end

    def perform_text_compile
      @perform_text_compile ||= plain_text
    end

    def perform_html_compile
      @perform_html_compile ||= begin
        compile_html
        inline_css
        configure_html
        finalize_document
      end
    end
    alias perform_full_compile perform_html_compile

    private

    def add_layout(html)
      document = Nokogiri::HTML(html)
      return html unless document.at_css('head').nil?

      BootstrapEmail::Erb.template(
        File.expand_path('../../core/layout.html.erb', __dir__),
        contents: html
      )
    end

    def build_premailer_doc(html)
      css_string = BootstrapEmail::SassCache.compile('bootstrap-email', config, style: :expanded)
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

    def compile_html
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

    def inline_css
      premailer.to_inline_css
    end

    def plain_text
      premailer.to_plain_text
    end

    def configure_html
      BootstrapEmail::Converter::HeadStyle.build(doc, config)
      BootstrapEmail::Converter::AddMissingMetaTags.build(doc)
      BootstrapEmail::Converter::VersionComment.build(doc)
    end

    def finalize_document
      doc.to_html(encoding: 'US-ASCII').tap do |html|
        BootstrapEmail::Converter::SupportUrlTokens.replace(html)
        BootstrapEmail::Converter::EnsureDoctype.replace(html)
        BootstrapEmail::Converter::ForceEncoding.replace(html)
        BootstrapEmail::Converter::BeautifyHTML.replace(html)
      end
    end
  end
end
