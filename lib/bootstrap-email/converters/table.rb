# frozen_string_literal: true

module BootstrapEmail
  module Converter
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
