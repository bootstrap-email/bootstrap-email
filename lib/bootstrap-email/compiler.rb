module BootstrapEmail
  class Compiler
    def initialize(type:, input:, options: {})
      case type
      when :rails
        html = add_layout!(input)
        @adapter = BootstrapEmail::RailsAdapter.new(html)
      when :string
        html = add_layout!(input)
        @adapter = BootstrapEmail::StringAdapter.new(html, options)
      when :file
        html = add_layout!(File.read(input))
        @adapter = BootstrapEmail::StringAdapter.new(html, options)
      end
    end

    def perform_full_compile
      compile_html!
      @adapter.inline_css!
      inject_head!
      @adapter.finalize_document!
    end

    def compile_html!
      BootstrapEmail::Component::AsTable.build(@adapter.doc)
      BootstrapEmail::Component::Button.build(@adapter.doc)
      BootstrapEmail::Component::Badge.build(@adapter.doc)
      BootstrapEmail::Component::Alert.build(@adapter.doc)
      BootstrapEmail::Component::Card.build(@adapter.doc)
      BootstrapEmail::Component::Hr.build(@adapter.doc)
      BootstrapEmail::Component::Container.build(@adapter.doc)
      BootstrapEmail::Component::Grid.build(@adapter.doc)
      BootstrapEmail::Component::Align.build(@adapter.doc)
      BootstrapEmail::Component::Padding.build(@adapter.doc)
      BootstrapEmail::Component::Margin.build(@adapter.doc)
      BootstrapEmail::Component::Spacing.build(@adapter.doc)
      BootstrapEmail::Component::Spacer.build(@adapter.doc)
      BootstrapEmail::Component::Table.build(@adapter.doc)
      BootstrapEmail::Component::Body.build(@adapter.doc)
      # color
    end

    def add_layout!(html)
      doc = Nokogiri::HTML(html)
      return unless doc.at_css('head').nil?

      namespace = OpenStruct.new(contents: ERB.new(doc.to_html).result)
      template_html = File.read(File.expand_path('../../core/layout.html.erb', __dir__))
      ERB.new(template_html).result(namespace.instance_eval { binding })
    end

    def inject_head!
      @adapter.doc.at_css('head').add_child(bootstrap_email_head)
    end

    private

    def bootstrap_email_head
      html_string = <<-INLINE
        <style type="text/css">
          #{purged_css_from_head}
        </style>
      INLINE
      html_string
    end

    def purged_css_from_head
      default, custom = BootstrapEmail::SassCache.compile('bootstrap-head').split('/*! allow_purge_after */')
      # get each CSS declaration
      custom.scan(/\w*\.[\w\-]*[\s\S\n]+?(?=})}{1}/).each do |group|
        # get the first class for each comma separated CSS declaration
        exist = group.scan(/(\.[\w\-]*).*?((,+?)|{+?)/).map(&:first).uniq.any? do |selector|
          !@adapter.doc.at_css(selector).nil?
        end
        custom.sub!(group, '') unless exist
      end
      (default + custom).gsub(/\n\s*\n+/, "\n")
    end

    # def color
    #   each_node('*[class*=bg-]') do |node|
    #     next if ['table', 'td'].include?(node.name) # skip if it is already on a table

    #     background_color_regex = /(bg-\w*(-\d+)?)/
    #     classes = node['class'].scan(background_color_regex).map(&:first).join(' ')
    #     node['class'] = node['class'].gsub(background_color_regex, '')
    #     node.replace(template('table', classes: classes, contents: node.to_html))
    #   end
    # end
  end
end
