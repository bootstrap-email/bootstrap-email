module BootstrapEmail
  module Converter
    class Hr < Base
      def build
        each_node('hr') do |node|
          default_margin = margin?(node) ? '' : 'my-5'
          node.replace(template('table', classes: "#{default_margin} hr #{node['class']}", contents: ''))
        end
      end
    end
  end
end
