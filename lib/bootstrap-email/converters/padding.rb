# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class Padding < Base
      def build
        each_node("*[class^=p-], *[class^=pt-], *[class^=pr-], *[class^=pb-], *[class^=pl-], *[class^=px-], *[class^=py-], *[class*=' p-'], *[class*=' pt-'], *[class*=' pr-'], *[class*=' pb-'], *[class*=' pl-'], *[class*=' px-'], *[class*=' py-']") do |node|
          next if %w[table td a].include?(node.name)

          padding_regex = /(p[trblxy]?-(lg-)?\d+)/
          classes = node['class'].gsub(padding_regex).to_a.join(' ')
          node['class'] = node['class'].gsub(padding_regex, '').strip
          node.replace(template('table', classes: classes, contents: node.to_html))
        end
      end
    end
  end
end
