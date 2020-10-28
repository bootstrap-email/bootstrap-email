module BootstrapEmail
  module Component
    class AsTable < Base
      def build
        each_node('.as-table') do |node|
          node.replace(template('table', classes: node['class'], contents: node.delete('class') && node.inner_html))
        end
      end
    end
  end
end
