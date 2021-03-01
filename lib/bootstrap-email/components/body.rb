module BootstrapEmail
  module Component
    class Body < Base
      def build
        body = doc.at_css('body')
        body.inner_html = template('body', classes: "#{body['class']} body", contents: body.inner_html)
      end
    end
  end
end
