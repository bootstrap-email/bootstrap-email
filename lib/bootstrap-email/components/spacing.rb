module BootstrapEmail
  module Component
    class Spacing < Base
      def build
        each_node('*[class*=space-y-]') do |node|
          spacer = node['class'].scan(/space-y-((lg-)?\d+)/)[0][0]
          # get all direct children except the first
          node.xpath('./*[position()>1] | ./tbody/tr/td/*[position()>1]').each do |child|
            html = ''
            html += template('div', classes: "s-#{spacer}", contents: nil)
            html += child.to_html
            child.replace(html)
          end
        end
      end
    end
  end
end
