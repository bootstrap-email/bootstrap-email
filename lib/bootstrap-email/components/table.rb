module BootstrapEmail
  module Component
    class Table < Base
      def build
        each_node('table') do |node|
          node['border'] = 0
          node['cellpadding'] = 0
          node['cellspacing'] = 0
        end
      end
    end
  end
end
