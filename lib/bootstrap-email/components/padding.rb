module BootstrapEmail
  module Component
    class Padding < Base
      def build
        each_node('*[class*=p-], *[class*=pt-], *[class*=pr-], *[class*=pb-], *[class*=pl-], *[class*=px-], *[class*=py-]') do |node|
          next if ['table', 'td', 'a'].include?(node.name)

          padding_regex = /(p[trblxy]?-\d+)/
          classes = node['class'].scan(padding_regex).join(' ')
          node['class'] = node['class'].gsub(padding_regex, '')
          node.replace(template('table', classes: classes, contents: node.to_html))
        end
      end
    end
  end
end
