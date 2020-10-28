module BootstrapEmail
  module Component
    class Badge < Base
      def build
        each_node('.badge') do |node|
          node.replace(template('table-left', classes: node['class'], contents: node.delete('class') && node.to_html))
        end
      end
    end
  end
end
