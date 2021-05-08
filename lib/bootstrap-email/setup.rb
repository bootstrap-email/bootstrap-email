module BootstrapEmail
  class << self
    def config
      @config ||= BootstrapEmail::Config.new
      @config
    end

    def load_options(options)
      @config ||= BootstrapEmail::Config.new
      @config.load_options(options)
      @config
    end

    def configure(&proc)
      @config ||= BootstrapEmail::Config.new
      yield @config
    end

    def reset_config!
      remove_instance_variable :@config if defined?(@config)
    end
  end
end
