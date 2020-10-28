module BootstrapEmail
  module Component
    class Alert < Base
      def build
        each_node('.alert') do |node|
          node.replace(template('table', classes: node['class'], contents: node.delete('class') && node.to_html))
        end
      end
    end
  end
end
