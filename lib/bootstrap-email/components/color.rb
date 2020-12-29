module BootstrapEmail
  module Component
    class Color < Base
      def build
        each_node('*[class*=bg-]') do |node|
          next unless ['div'].include?(node.name) # only do automatic thing for div

          node.replace(template('table', classes: "#{node['class']} w-full", contents: node.delete('class') && node.inner_html))
        end
      end
    end
  end
end
