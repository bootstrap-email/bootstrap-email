module BootstrapEmail
  module Component
    class Spacing < Base
      def build
        each_node('*[class*=space-y-]') do |node|
          spacer = node['class'].scan(/space-y-((lg-)?\d+)/)[0][0]
          # get all direct children except the first
          node.xpath('./*[position() < last()] | ./tbody/tr/td/*[position() < last()]').each do |child|
            next if margin_bottom?(child)

            add_class(child, "mb-#{spacer}")
          end
        end
      end
    end
  end
end
