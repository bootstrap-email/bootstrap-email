module BootstrapEmail
  module Converter
    class SupportUrlTokens < Base
      OPEN_BRACKETS = URI.encode('{{').freeze
      CLOSE_BRACKETS = URI.encode('}}').freeze

      def self.replace(html)
        regex = /((href|src)=(\"|\'))((#{Regexp.quote(OPEN_BRACKETS)}).*?(#{Regexp.quote(CLOSE_BRACKETS)}))(\"|\')/
        if regex.match?(html)
          html.gsub!(regex) do |match|
            "#{$1}#{URI.decode($4)}#{$7}"
          end
        end
      end
    end
  end
end
