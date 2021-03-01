module BootstrapEmail
  module Component
    class ForceEncoding < Base
      def build
        body = doc.at_css('body')
        # force utf-8 character encoded in iOS Mail: https://github.com/bootstrap-email/bootstrap-email/issues/50
        body.append_child('<div style="display: none;">&#10175;</div>')
      end
    end
  end
end
