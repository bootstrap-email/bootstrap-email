# frozen_string_literal: true

module BootstrapEmail
  module Rails
    class MailBuilder
      attr_reader :message, :bootstrap_email

      def self.perform(mail)
        new(mail).perform if mail
      end

      def initialize(mail)
        @message = mail
        @bootstrap_email = BootstrapEmail::Compiler.new(html_part.decoded, type: :string)
      end

      def perform
        replace_html_part(generate_html_part_replacement)
        message
      end

      private

      # Much of this files derives from: https://github.com/fphilipe/premailer-rails/blob/2870060f9740de1c3f7a1da0acfc7b88e3181077/lib/premailer/rails/hook.rb

      def message_contains_html?
        html_part.present?
      end

      # Returns true if the message itself has a content type of text/html, thus
      # it does not contain other parts such as alternatives and attachments.
      def pure_html_message?
        message.content_type&.include?('text/html')
      end

      def generate_html_part_replacement
        if generate_text_part?
          generate_alternative_part
        else
          html = bootstrap_email.perform_html_compile
          build_html_part(html)
        end
      end

      def generate_text_part?
        BootstrapEmail.static_config.generate_rails_text_part && !message.text_part
      end

      def generate_alternative_part
        compiled = bootstrap_email.perform_multipart_compile

        part = Mail::Part.new(content_type: 'multipart/alternative')
        part.add_part(build_text_part(compiled[:text]))
        part.add_part(build_html_part(compiled[:html]))

        part
      end

      def build_html_part(html)
        Mail::Part.new do
          content_type 'text/html; charset=UTF-8'
          body html
        end
      end

      def build_text_part(text)
        Mail::Part.new do
          content_type "text/plain; charset=#{text.encoding}"
          body text
        end
      end

      def html_part
        if pure_html_message?
          message
        else
          message.html_part
        end
      end

      def replace_html_part(new_part)
        if pure_html_message?
          replace_in_pure_html_message(new_part)
        else
          replace_part_in_list(message.parts, html_part, new_part)
        end
      end

      # If the new part is a pure text/html part, the body and its content type
      # are used for the message. If the new part is
      def replace_in_pure_html_message(new_part)
        if new_part.content_type.include?('text/html')
          message.body = new_part.decoded
          message.content_type = new_part.content_type
        else
          message.body = nil
          message.content_type = new_part.content_type
          new_part.parts.each do |part|
            message.add_part(part)
          end
        end
      end

      def replace_part_in_list(parts_list, old_part, new_part)
        if (index = parts_list.index(old_part))
          parts_list[index] = new_part
        else
          parts_list.any? do |part|
            replace_part_in_list(part.parts, old_part, new_part) if part.respond_to?(:parts)
          end
        end
      end
    end
  end
end
