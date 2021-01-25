module BootstrapEmail
  module Component
    class Paragraph < Base
      def build
        each_node('p') do |node|
          next if margin?(node) || space_y?(node)

          node['class'] ||= ''
          node['class'] += 'mb-4'
        end
      end

      private

      def margin?(node)
        node['class'].to_s.match?(/m[tby]{1}-(lg-)?\d+/)
      end

      def space_y?(node)
        node.parent['class'].to_s.match?(/space-y-(lg-)?\d+/)
      end
    end
  end
end
