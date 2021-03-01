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

      private

      def template(file, locals_hash = {})
        locals_hash[:classes] = locals_hash[:classes].split.join(' ') if locals_hash[:classes]
        BootstrapEmail::Erb.template(
          File.expand_path("../../../core/templates/#{file}.html.erb", __dir__),
          locals_hash
        )
      end

      def each_node(css_lookup, &blk)
        # sort by youngest child and traverse backwards up the tree
        doc.css(css_lookup).sort_by { |n| n.ancestors.size }.reverse!.each(&blk)
      end

      def add_class(node, class_name)
        node['class'] ||= ''
        node['class'] += class_name
      end

      def margin?(node)
        margin_top?(node) || margin_bottom?(node)
      end

      def margin_top?(node)
        node['class'].to_s.match?(/m[ty]{1}-(lg-)?\d+/)
      end

      def margin_bottom?(node)
        node['class'].to_s.match?(/m[by]{1}-(lg-)?\d+/)
      end
    end
  end
end
