module BootstrapEmail
  module Converter
    class SupportUrlTokens < Base
      def self.replace(html)
        regex = /((href|src)=(\"|\'))((%7B%7B).*?(%7D%7D))(\"|\')/
        if regex.match?(html)
          html.gsub!(regex) do |match|
            "#{$1}#{URI.decode($4)}#{$7}"
          end
        end
      end
    end
  end
end
