# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class Align < Base
      def build
        %w[left center right].each do |type|
          full_type = "ax-#{type}"
          each_node(".#{full_type}") do |node|
            align_helper(node, full_type, type)
          end
        end
      end

      def align_helper(node, full_type, type)
        unless table?(node) || td?(node)
          node['class'] = node['class'].sub(full_type, '').strip
          node = node.replace(template('table', classes: full_type, contents: node.to_html))[0]
        end
        node['align'] = type
      end
    end
  end
end
