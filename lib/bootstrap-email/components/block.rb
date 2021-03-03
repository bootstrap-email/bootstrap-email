module BootstrapEmail
  module Component
    class Block < Base
      def build
        each_node('block') do |node|
          node.replace(template('table', classes: "table-as-block #{node['class']}", contents: node.inner_html))
        end
      end
    end
  end
end
