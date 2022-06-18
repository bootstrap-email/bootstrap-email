# frozen_string_literal: true

module BootstrapEmail
  class << self
    def static_config
      @static_config ||= BootstrapEmail::ConfigStore.new
    end

    def configure
      yield static_config
    end

    def reset_config!
      remove_instance_variable :@static_config if defined?(@static_config)
    end

    def clear_sass_cache!
      FileUtils.rm_rf(static_config.sass_cache_location)
    end
  end
end
