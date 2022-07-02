# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class PreviewText < Base
      def build
        preview_node = doc.at_css('preview')
        return if preview_node.nil?

        # https://www.litmus.com/blog/the-little-known-preview-text-hack-you-may-want-to-use-in-every-email/
        # apply spacing after the text max of 278 characters so it doesn't show body text
        preview_node.inner_html += '&#847; &zwnj; &nbsp; ' * [(278 - preview_node.content.length.to_i), 0].max
        node = template('div', classes: 'preview', contents: preview_node.content)
        preview_node.remove

        body = doc.at_css('body')
        body.prepend_child(node)
      end
    end
  end
end
