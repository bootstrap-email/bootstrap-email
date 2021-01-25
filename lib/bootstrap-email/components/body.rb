module BootstrapEmail
  module Component
    class Body < Base
      def build
        each_node('body') do |node|
          node.replace('<body>' + preview_text.to_s + template('body', classes: "#{node['class']} body", contents: node.inner_html) + '</body>')
        end
      end

      def preview_text
        preview_node = doc.at_css('preview')
        return if preview_node.nil?

        # apply spacing after the text max of 100 characters so it doesn't show body text
        preview_node.content += '&nbsp;' * [(100 - preview_node.content.length.to_i), 0].max
        node = template('div', classes: 'preview', contents: preview_node.content)
        preview_node.remove
        node
      end
    end
  end
end
