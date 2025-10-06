# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class Spacer < Base
      def build
        each_node('*[class*=s-]') do |node|
          next unless node['class'].split.any? { |cls| cls.match?(/^s(-lg)?-\d+$/) }

          node.replace(template('table', classes: "#{node['class']} w-full", contents: '&nbsp;'))
        end
      end
    end
  end
end
