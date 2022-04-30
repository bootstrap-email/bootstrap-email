# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class PreviewText < Base
      def build
        preview_node = doc.at_css('preview')
        return if preview_node.nil?

        # apply spacing after the text max of 100 characters so it doesn't show body text
        preview_node.inner_html += '&nbsp;' * [(100 - preview_node.content.length.to_i), 0].max
        node = template('div', classes: 'preview', contents: preview_node.content)
        preview_node.remove

        body = doc.at_css('body')
        body.prepend_child(node)
      end
    end
  end
end
