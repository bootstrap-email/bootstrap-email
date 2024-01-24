# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class Badge < Base
      def build
        each_node('.badge') do |node|
          classes = node['class'].split(' ')
          node_classes = classes.reject { |c| c =~ /^border/ }.join(' ')
          child_classes = classes.select { |c| c =~ /^border/ }.join(' ')
          node.replace(template('table-left', classes: node_classes, child_classes: child_classes, contents: node.delete('class') && node.to_html))
        end
      end
    end
  end
end
