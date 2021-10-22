module BootstrapEmail
  module Converter
    class BeautifyHTML < Base
      def self.replace(html)
        html.replace(HtmlBeautifier.beautify(html))
      end
    end
  end
end
