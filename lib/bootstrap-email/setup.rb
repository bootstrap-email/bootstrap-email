# frozen_string_literal: true

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

    def configure
      @config ||= BootstrapEmail::Config.new
      yield @config
    end

    def reset_config!
      remove_instance_variable :@config if defined?(@config)
    end

    def clear_sass_cache!
      FileUtils.rm_rf(BootstrapEmail.config.sass_cache_location)
    end
  end
end
