# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class SupportUrlTokens < Base
      OPEN_BRACKETS = CGI.escape('{{').freeze
      OPEN_PERCENT = (CGI.escape('{') + '%').freeze
      CLOSE_BRACKETS = CGI.escape('}}').freeze
      CLOSE_PERCENT = ('%' + CGI.escape('}')).freeze

      def self.replace(html)
        regex = /((href|src)=("|'))(.*?((#{Regexp.quote(OPEN_BRACKETS)}|#{Regexp.quote(OPEN_PERCENT)}).*?(#{Regexp.quote(CLOSE_BRACKETS)}|#{Regexp.quote(CLOSE_PERCENT)})).*?)("|')/
        if regex.match?(html)
          puts '*********** ITS A MATCH'
        else
          puts '*********** ITS NOT A MATCH'
        end
        return unless regex.match?(html)

        inner_regex = /((#{Regexp.quote(OPEN_BRACKETS)}|#{Regexp.quote(OPEN_PERCENT)}).*?(#{Regexp.quote(CLOSE_BRACKETS)}|#{Regexp.quote(CLOSE_PERCENT)}))/

        html.gsub!(regex) do |_match|
          start_text = Regexp.last_match(1)
          middle_text = Regexp.last_match(4)
          end_text = Regexp.last_match(8)
          middle_text.gsub!(inner_regex) do |match|
            CGI.unescape(match)
          end
          puts 'Text pieces!!!!!!!!!!!!'
          puts start_text
          puts middle_text
          puts end_text
          "#{start_text}#{middle_text}#{end_text}"
        end
      end
    end
  end
end
