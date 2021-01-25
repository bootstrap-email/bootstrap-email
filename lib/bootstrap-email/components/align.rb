module BootstrapEmail
  module Component
    class Align < Base
      def build
       ['left', 'center', 'right'].each do |type|
         each_node(".align-#{type}") do |node|
           align_helper(node, type)
         end
       end
      end

      def align_helper(node, type)
        if node.name != 'table'
          node['class'] = node['class'].sub("align-#{type}", '')
          node = node.replace(template('table', classes: "align-#{type}", contents: node.to_html))[0]
        end
        node['align'] = type
      end
    end
  end
end
