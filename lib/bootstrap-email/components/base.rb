module BootstrapEmail
  module Component
    class Base
      attr_reader :doc
      def initialize(doc)
        @doc = doc
      end

      def self.build(doc)
        new(doc).build
      end

      def template(file, locals_hash = {})
        locals_hash[:classes] = locals_hash[:classes].split.join(' ') if locals_hash[:classes]
        namespace = OpenStruct.new(locals_hash)
        template_html = File.read(File.expand_path("../../../core/templates/#{file}.html.erb", __dir__))
        ERB.new(template_html).result(namespace.instance_eval { binding })
      end

      def each_node(css_lookup, &blk)
        # sort by youngest child and traverse backwards up the tree
        doc.css(css_lookup).sort_by { |n| n.ancestors.size }.reverse!.each(&blk)
      end
    end
  end
end
