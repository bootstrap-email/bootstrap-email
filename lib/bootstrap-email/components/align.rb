module BootstrapEmail
  module Component
    class Align < Base
      def build
       ['left', 'center', 'right'].each do |type|
        type = "align-#{type}"
         each_node(".#{type}") do |node|
           align_helper(node, type)
         end
       end
      end

      def align_helper(node, type)
        unless is_table?(node)
          node['class'] = node['class'].sub(type, '')
          node = node.replace(template('table', classes: type, contents: node.to_html))[0]
        end
        node['align'] = type
      end
    end
  end
end
