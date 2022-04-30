# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class Card < Base
      def build
        each_node('.card') do |node|
          node.replace(template('table', classes: node['class'], contents: node.inner_html))
        end
        each_node('.card-body') do |node|
          node.replace(template('table', classes: node['class'], contents: node.inner_html))
        end
      end
    end
  end
end
