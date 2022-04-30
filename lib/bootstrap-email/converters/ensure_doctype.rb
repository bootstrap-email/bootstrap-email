module BootstrapEmail
  module Converter
    class EnsureDoctype < Base
      def self.replace(html)
        # ensure the proper XHTML doctype which ensures best compatibility in email clients
        # https://github.com/bootstrap-email/bootstrap-email/discussions/168
        html.gsub!(
          /<!DOCTYPE.*(\[[\s\S]*?\])?>/,
          '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'
        )
      end
    end
  end
end
