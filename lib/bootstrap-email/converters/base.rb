# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class Base
      attr_reader :doc

      def initialize(doc)
        @doc = doc
        @cached_templates = {}
      end

      def self.build(doc)
        new(doc).build
      end

      private

      def template(file, locals_hash = {})
        locals_hash[:classes] = locals_hash[:classes].to_s.split.join(' ')
        locals_hash[:content] ||= nil
        if @cached_templates[file]
          string = @cached_templates[file]
        else
          path = File.expand_path("../../../core/templates/#{file}.html", __dir__)
          string = File.read(path).chop # read and remove trailing newline
          @cached_templates[file] = string
        end
        locals_hash.each do |key, value|
          string = string.sub("{{ #{key} }}", value.to_s)
        end
        string
      end

      def each_node(css_lookup, &blk)
        # sort by youngest child and traverse backwards up the tree
        doc.css(css_lookup).sort_by { |n| n.ancestors.size }.reverse!.each(&blk)
      end

      def add_class(node, class_name)
        node['class'] ||= ''
        # remove double spaces and strip white space from ends
        node['class'] = "#{node['class']} #{class_name}".gsub(/\s+/, ' ').strip
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

      def table?(node)
        node.name == 'table'
      end

      def td?(node)
        node.name == 'td'
      end
    end
  end
end
