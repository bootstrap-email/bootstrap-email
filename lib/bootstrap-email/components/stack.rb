module BootstrapEmail
  module Component
    class Stack < Base
      def build
        stack_x
        stack_y
      end

      def stack_x
        each_node('.stack-x') do |node|
          html = ''
          node.xpath('./*').each do |child|
            html += template('td', classes: 'stack-cell', contents: template('div', classes: 'stack-item', contents: child.to_html))
          end
          node.replace(template('table-to-tr', classes: node['class'], contents: html))
        end
      end

      def stack_y
        each_node('.stack-y') do |node|
          html = ''
          node.xpath('./*').each do |child|
            html += template('tr', classes: 'stack-cell', contents: template('div', classes: 'stack-item', contents: child.to_html))
          end
          node.replace(template('table-to-tbody', classes: node['class'], contents: html))
        end
      end
    end
  end
end
