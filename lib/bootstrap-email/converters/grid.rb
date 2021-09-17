module BootstrapEmail
  module Converter
    class Grid < Base
      def build
        each_node('.row') do |node|
          if node.at("./*[contains(@class, 'col-lg-')]")
            add_class(node, 'row-responsive')
          end
          node.replace(template('div', classes: node['class'], contents: template('table-to-tr', contents: node.inner_html)))
        end
        each_node('*[class*=col]') do |node|
          node.replace(template('td', classes: node['class'], contents: node.inner_html))
        end
      end
    end
  end
end
