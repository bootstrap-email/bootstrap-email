module BootstrapEmail
  module Converter
    class ForceEncoding < Base
      def build
        body = doc.at_css('body')
        body.add_child('<force-encoding></force-encoding>')
      end

      def self.replace(html)
        # force utf-8 character encoded in iOS Mail: https://github.com/bootstrap-email/bootstrap-email/issues/50
        # this needs to be done after the document has been outputted to a string so it doesn't get converted
        html.sub('<force-encoding></force-encoding>', '<div id="force-encoding-to-utf-8" style="display: none;">&#10175;</div>')
      end
    end
  end
end
