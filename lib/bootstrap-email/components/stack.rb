module BootstrapEmail
  module Component
    class Stack < Base
      def build
        stack_x
        stack_y
      end

      def stack_x
        each_node('.stack-x') do |node|
          node.replace(template('table-to-tr', classes: node['class'], contents: node.inner_html))
          node.xpath('./tbody/tr/*').each do |child|
            child.replace(template('td', contents: node.to_html))
          end
        end
      end

      def stack_y
        each_node('.stack-y') do |node|
          node.replace(template('table-to-tbody', classes: node['class'], contents: node.inner_html))
          node.xpath('./tbody/*').each do |child|
            child.replace(template('tr', contents: node.to_html))
          end
        end
      end
    end
  end
end

# .stack-x.gap-4.align-center
#   div
#   div
#   div

# table align="center"
#   tbody
#     tr
#       td.pr-4
#         div
#       td.pr-4
#         div
#       td
#         div
