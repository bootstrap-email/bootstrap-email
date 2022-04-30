# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class Margin < Base
      def build
        each_node("*[class^='my-'], *[class^='mt-'], *[class^='mb-'], *[class*=' my-'], *[class*=' mt-'], *[class*=' mb-']") do |node|
          top_class = node['class'][/m[ty]{1}-(lg-)?(\d+)/]
          bottom_class = node['class'][/m[by]{1}-(lg-)?(\d+)/]
          node['class'] = node['class'].gsub(/(m[tby]{1}-(lg-)?\d+)/, '').strip
          html = ''
          html += template('div', classes: "s-#{top_class.gsub(/m[ty]{1}-/, '')}", contents: nil) if top_class
          html += node.to_html
          html += template('div', classes: "s-#{bottom_class.gsub(/m[by]{1}-/, '')}", contents: nil) if bottom_class
          node.replace(html)
        end
      end
    end
  end
end
