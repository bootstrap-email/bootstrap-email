# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class SupportUrlTokens < Base
      OPEN_BRACKETS = [CGI.escape('{{'), '{{', "#{CGI.escape('{')}%", '{%'].freeze
      CLOSE_BRACKETS = [CGI.escape('}}'), '}}', "%#{CGI.escape('}')}", '%}'].freeze

      def self.replace(html)
        regex = /((href|src)=("|'))(.*?((#{opening_regex}).*?(#{closing_regex})).*?)("|')/
        return unless regex.match?(html)

        inner_regex = /((#{opening_regex}).*?(#{closing_regex}))/

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

      def self.opening_regex
        OPEN_BRACKETS.map { |bracket| Regexp.quote(bracket) }.join('|')
      end

      def self.closing_regex
        CLOSE_BRACKETS.map { |bracket| Regexp.quote(bracket) }.join('|')
      end
    end
  end
end
