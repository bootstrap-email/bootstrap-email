module BootstrapEmail
  class Erb
    def self.template(path, locals_hash = {})
      namespace = OpenStruct.new(locals_hash)
      template_html = File.read(path)
      ERB.new(template_html).result(namespace.instance_eval { binding })
    end
  end
end
