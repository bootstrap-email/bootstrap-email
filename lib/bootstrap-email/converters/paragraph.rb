module BootstrapEmail
  module Converter
    class Paragraph < Base
      def build
        each_node('p') do |node|
          next if margin?(node)

          add_class(node, 'mb-4')
        end
      end
    end
  end
end
