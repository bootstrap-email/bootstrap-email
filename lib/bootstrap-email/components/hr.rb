module BootstrapEmail
  module Component
    class Hr < Base
      def build
        each_node('hr') do |node|
          default_margin = node['class'].to_s.match?(/m[tby]{1}-(lg-)?\d+/) ? '' : 'my-5'
          node.replace(template('table', classes: "#{default_margin} hr #{node['class']}", contents: ''))
        end
      end
    end
  end
end
