module BootstrapEmail
  module Component
    class VersionComment < Base
      def build
        doc.at_css('head').prepend_child(bootstrap_email_comment)
      end

      private

      def bootstrap_email_comment
        "\n    <!-- Compiled with Bootstrap Email version: #{BootstrapEmail::VERSION} -->"
      end
    end
  end
end
