# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class Spacer < Base
      def build
        each_node('*[class*=s-]') do |node|
          node.replace(template('table', classes: "#{node['class']} w-full", contents: '&nbsp;'))
        end
      end
    end
  end
end
