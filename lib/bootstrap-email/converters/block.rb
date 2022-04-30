# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class Block < Base
      def build
        each_node('block, .to-table') do |node|
          # add .to-table if it's not already there
          class_name = node['class'].to_s.split << 'to-table'
          node.replace(template('table', classes: class_name.uniq.join(' '), contents: node.inner_html))
        end
      end
    end
  end
end
