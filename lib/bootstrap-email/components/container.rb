module BootstrapEmail
  module Component
    class Container < Base
      def build
        each_node('.container') do |node|
          node.replace(template('container', classes: node['class'], contents: node.inner_html))
        end
        each_node('.container-fluid') do |node|
          node.replace(template('table', classes: node['class'], contents: node.inner_html))
        end
      end
    end
  end
end
