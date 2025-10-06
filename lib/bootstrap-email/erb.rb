# frozen_string_literal: true

module BootstrapEmail
  class Erb
    def self.template(path, locals_hash = {})
      namespace = Struct.new(*locals_hash.keys, keyword_init: true).new(**locals_hash)
      template_html = File.read(path)
      ERB.new(template_html).result(namespace.instance_eval { binding })
    end
  end
end
