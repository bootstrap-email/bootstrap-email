module BootstrapEmail
  module Converter
    class ForceEncoding < Base
      def self.replace(html)
        # force utf-8 character encoded in iOS Mail: https://github.com/bootstrap-email/bootstrap-email/issues/50
        # this needs to be done after the document has been outputted to a ascii string so it doesn't get converted
        html.sub!(
          '<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">',
          '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">'
        )
      end
    end
  end
end
