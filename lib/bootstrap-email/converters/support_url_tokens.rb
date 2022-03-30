module BootstrapEmail
  module Converter
    class SupportUrlTokens < Base
      OPEN_BRACKETS = CGI.escape('{{').freeze
      CLOSE_BRACKETS = CGI.escape('}}').freeze

      def self.replace(html)
        regex = /((href|src)=(\"|\').*?)((#{Regexp.quote(OPEN_BRACKETS)}).*?(#{Regexp.quote(CLOSE_BRACKETS)}))(.*?(\"|\'))/
        if regex.match?(html)
          html.gsub!(regex) do |match|
            "#{$1}#{CGI.unescape($4)}#{$7}"
          end
        end
      end
    end
  end
end
