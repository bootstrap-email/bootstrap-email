# frozen_string_literal: true

module BootstrapEmail
  module Rails
    class MailBuilder
      attr_reader :mail, :bootstrap_email

      def self.perform(mail)
        new(mail).perform if mail
      end

      def initialize(mail)
        @mail = mail
        @bootstrap_email = BootstrapEmail::Compiler.new(html_part, type: :string)
      end

      def perform
        add_mail_parts
        mail
      end

      private

      def html_part
        (mail.html_part || mail).body.raw_source
      end

      def add_mail_parts
        if BootstrapEmail.static_config.generate_rails_text_part
          mail.parts << build_alternative_part
        else
          html = bootstrap_email.perform_full_compile
          mail.parts << build_html_part(html)
        end
      end

      def build_alternative_part
        compiled = bootstrap_email.perform_multipart_compile

        part = Mail::Part.new(content_type: 'multipart/alternative')
        part.add_part(build_text_part(compiled[:text]))
        part.add_part(build_html_part(compiled[:html]))

        part
      end

      def build_html_part(html)
        Mail::Part.new do
          content_type "text/html; charset=#{html.encoding}"
          body html
        end
      end

      def build_text_part(text)
        Mail::Part.new do
          content_type "text/plain; charset=#{text.encoding}"
          body text
        end
      end
    end
  end
end
