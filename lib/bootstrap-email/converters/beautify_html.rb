module BootstrapEmail
  module Converter
    class BeautifyHTML < Base
      def self.replace(html)
        # Pretty print format the HTML string and add a trailing newline
        html.replace(HtmlBeautifier.beautify(html) + "\n")
      end
    end
  end
end
