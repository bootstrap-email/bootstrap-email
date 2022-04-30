module BootstrapEmail
  module Converter
    class HeadStyle < Base
      def build
        doc.at_css('head').add_child(bootstrap_email_head)
      end

      private

      def bootstrap_email_head
        <<-HTML
          <style type="text/css">
            #{purged_css_from_head}
          </style>
        HTML
      end

      def purged_css_from_head
        default, custom = BootstrapEmail::SassCache.compile('bootstrap-head').split('/*! allow_purge_after */')
        # get each CSS declaration
        custom.scan(/\w*\.[\w\-]*[\s\S\n]+?(?=})}{1}/).each do |group|
          # get the first class for each comma separated CSS declaration
          exist = group.scan(/(\.[\w\-]*).*?((,+?)|{+?)/).map(&:first).uniq.any? do |selector|
            !doc.at_css(selector).nil?
          end
          custom.sub!(group, '') unless exist
        end
        (default + custom).gsub(/\n\s*\n+/, "\n")
      end
    end
  end
end
