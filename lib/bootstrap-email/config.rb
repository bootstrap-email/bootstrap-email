# frozen_string_literal: true

module BootstrapEmail
  class Config
    def initialize(options = {})
      @config_store = BootstrapEmail::ConfigStore.new(options)
      file = File.expand_path('bootstrap-email.config.rb', Dir.pwd)
      if options[:config_path]
        require_relative options[:config_path]
      elsif File.exist?(file)
        require_relative file
      end
    end

    def sass_string_for(type:)
      # look for custom sass string
      sub_type = type.sub('bootstrap-', '')
      string = config_for_option("sass_#{sub_type}_string")
      return string unless string.nil?

      # look for custom sass path
      path = config_for_option("sass_#{sub_type}_location")
      return File.read(path) unless path.nil?

      # look up and return others if found in default locations
      lookup_locations = ["#{type}.scss", "app/assets/stylesheets/#{type}.scss"]
      locations = lookup_locations.map { |location| File.expand_path(location, Dir.pwd) }.select { |location| File.exist?(location) }
      File.read(locations.first) if locations.any?
    end

    def sass_load_paths
      paths_array = [SassCache::SASS_DIR]
      custom_load_paths = config_for_option(:sass_load_paths) || []
      paths_array.concat(custom_load_paths)
    end

    def sass_cache_location
      option = config_for_option(:sass_cache_location)
      return option unless option.nil?

      if defined?(::Rails) && ::Rails.root
        ::Rails.root.join('tmp', 'cache', 'bootstrap-email', '.sass-cache')
      elsif File.writable?(Dir.pwd)
        File.join(Dir.pwd, '.sass-cache', 'bootstrap-email')
      else
        File.join(Dir.tmpdir, '.sass-cache', 'bootstrap-email')
      end
    end

    def sass_log_enabled?
      option = config_for_option(:sass_log_enabled)
      option.nil? ? true : option
    end

    private

    def config_for_option(option)
      if @config_store.did_set?(option)
        @config_store.public_send(option)
      else
        BootstrapEmail.static_config.public_send(option)
      end
    end
  end
end
