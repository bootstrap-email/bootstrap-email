module BootstrapEmail
  module Component
    class Spacing < Base
      def build
        each_node('*[class*=space-y-]') do |node|
          spacer = node['class'].scan(/space-y-((lg-)?\d+)/)[0][0]
          # get all direct children except the first
          node.xpath('./*[position()>1] | ./tbody/tr/td/*[position()>1]').each do |child|
            next if margin_top?(child)

            add_class(child, "mt-#{spacer}")
          end
        end
      end
    end
  end
end
