# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class SupportUrlTokens < Base
      OPEN_BRACKETS = CGI.escape('{{').freeze
      CLOSE_BRACKETS = CGI.escape('}}').freeze

      def self.replace(html)
        regex = /((href|src)=("|'))(.*?((#{Regexp.quote(OPEN_BRACKETS)}).*?(#{Regexp.quote(CLOSE_BRACKETS)})).*?)("|')/
        return unless regex.match?(html)

        inner_regex = /((#{Regexp.quote(OPEN_BRACKETS)}).*?(#{Regexp.quote(CLOSE_BRACKETS)}))/

        html.gsub!(regex) do |_match|
          start_text = Regexp.last_match(1)
          middle_text = Regexp.last_match(4)
          end_text = Regexp.last_match(8)
          middle_text.gsub!(inner_regex) do |match|
            CGI.unescape(match)
          end
          "#{start_text}#{middle_text}#{end_text}"
        end
      end
    end
  end
end
