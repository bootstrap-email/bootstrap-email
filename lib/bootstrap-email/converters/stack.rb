# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class Stack < Base
      def build
        stack_row
        stack_col
      end

      def stack_row
        each_node('.stack-row') do |node|
          html = ''
          node.xpath('./*').each do |child|
            html += template('td', classes: 'stack-cell', contents: child.to_html)
          end
          node.replace(template('table-to-tr', classes: node['class'], contents: html))
        end
      end

      def stack_col
        each_node('.stack-col') do |node|
          html = ''
          node.xpath('./*').each do |child|
            html += template('tr', classes: 'stack-cell', contents: child.to_html)
          end
          node.replace(template('table-to-tbody', classes: node['class'], contents: html))
        end
      end
    end
  end
end
