# frozen_string_literal: true

module BootstrapEmail
  module Converter
    class AddMissingMetaTags < Base
      META_TAGS = [
        { query: 'meta[http-equiv="Content-Type"]',
          code: '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">' },
        { query: 'meta[http-equiv="x-ua-compatible"]',
          code: '<meta http-equiv="x-ua-compatible" content="ie=edge">' },
        { query: 'meta[name="x-apple-disable-message-reformatting"]',
          code: '<meta name="x-apple-disable-message-reformatting">' },
        { query: 'meta[name="viewport"]',
          code: '<meta name="viewport" content="width=device-width, initial-scale=1">' },
        { query: 'meta[name="format-detection"]',
          code: '<meta name="format-detection" content="telephone=no, date=no, address=no, email=no">' }
      ].reverse.freeze

      def build
        META_TAGS.each do |tag_hash|
          doc.at_css('head').prepend_child(tag_hash[:code]) unless doc.at_css(tag_hash[:query])
        end
      end
    end
  end
end
