# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class Button < Base
      def build
        each_node('.btn') do |node|
          node.replace(template('table', classes: node['class'], contents: node.delete('class') && node.to_html))
        end
      end
    end
  end
end
