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
      build_premailer_doc(html, options)
    end

    def perform_full_compile
      compile_html!
      inline_css!
      inject_head!
      inject_comment!
      finalize_document!
    end

    private

    def build_premailer_doc(html, options)
      html = add_layout!(html)
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

    def add_layout!(html)
      document = Nokogiri::HTML(html)
      return document.to_html unless document.at_css('head').nil?

      namespace = OpenStruct.new(contents: ERB.new(document.to_html).result)
      template_html = File.read(File.expand_path('../../core/layout.html.erb', __dir__))
      ERB.new(template_html).result(namespace.instance_eval { binding })
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
      BootstrapEmail::Component::Color.build(doc)
      BootstrapEmail::Component::Spacing.build(doc)
      BootstrapEmail::Component::Padding.build(doc)
      BootstrapEmail::Component::Margin.build(doc)
      BootstrapEmail::Component::Spacer.build(doc)
      BootstrapEmail::Component::Table.build(doc)
      BootstrapEmail::Component::Body.build(doc)
      BootstrapEmail::Component::Preview.build(doc)
      BootstrapEmail::Component::ForceEncoding.build(doc)
    end

    def inline_css!
      premailer.to_inline_css
    end

    def inject_head!
      doc.at_css('head').add_child(bootstrap_email_head)
    end

    def inject_comment!
      doc.at_css('head').prepend_child(bootstrap_email_comment)
    end

    def finalize_document!
      case type
      when :rails
        (@mail.html_part || @mail).body = doc.to_html
        @mail
      when :string, :file
        doc.to_html
      end
    end

    def bootstrap_email_head
      html_string = <<-INLINE
        <style type="text/css">
          #{purged_css_from_head}
        </style>
      INLINE
      html_string
    end

    def bootstrap_email_comment
      "\n    <!-- Compiled with Bootstrap Email version: #{BootstrapEmail::VERSION} -->"
    end

    def purged_css_from_head
      default, custom = BootstrapEmail::SassCache.compile('bootstrap-head').split('/*! allow_purge_after */')
      # get each CSS declaration
      custom.scan(/\w*\.[\w\-]*[\s\S\n]+?(?=})}{1}/).each do |group|
        # get the first class for each comma separated CSS declaration
        exist = group.scan(/(\.[\w\-]*).*?((,+?)|{+?)/).map(&:first).uniq.any? do |selector|
          !doc.at_css(selector).nil?
        end
        custom.sub!(group, '') unless exist
      end
      (default + custom).gsub(/\n\s*\n+/, "\n")
    end
  end
end
