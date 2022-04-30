# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class SupportUrlTokens < Base
      OPEN_BRACKETS = CGI.escape('{{').freeze
      CLOSE_BRACKETS = CGI.escape('}}').freeze

      def self.replace(html)
        regex = /((href|src)=("|').*?)((#{Regexp.quote(OPEN_BRACKETS)}).*?(#{Regexp.quote(CLOSE_BRACKETS)}))(.*?("|'))/
        if regex.match?(html)
          html.gsub!(regex) do |_match|
            "#{Regexp.last_match(1)}#{CGI.unescape(Regexp.last_match(4))}#{Regexp.last_match(7)}"
          end
        end
      end
    end
  end
end
