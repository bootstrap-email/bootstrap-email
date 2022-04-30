# frozen_string_literal: true

module BootstrapEmail
  class Config
    attr_writer :sass_email_location, # path to main sass file
                :sass_head_location,  # path to head sass file
                :sass_load_paths,     # array of directories for loading sass imports
                :sass_cache_location, # path to tmp folder for sass cache
                :sass_log_enabled    # turn on or off sass log when caching new sass

    def load_options(options)
      file = File.expand_path('bootstrap-email.config.rb', Dir.pwd)
      if options[:config_path]
        require_relative options[:config_path]
      elsif File.exist?(file)
        require_relative file
      end
      options.each { |name, value| instance_variable_set("@#{name}", value) }
    end

    def sass_location_for(type:)
      ivar = instance_variable_get("@sass_#{type.sub('bootstrap-', '')}_location")
      return ivar if ivar

      lookup_locations = ["#{type}.scss", "app/assets/stylesheets/#{type}.scss"]
      locations = lookup_locations.map { |location| File.expand_path(location, Dir.pwd) }.select { |location| File.exist?(location) }
      locations.first if locations.any?
    end

    def sass_load_paths
      paths_array = [SassCache::SASS_DIR]
      @sass_load_paths ||= []
      paths_array.concat(@sass_load_paths)
    end

    def sass_cache_location
      @sass_cache_location ||= begin
        if defined?(::Rails) && ::Rails.root
          ::Rails.root.join('tmp', 'cache', 'bootstrap-email', '.sass-cache')
        elsif File.writable?(Dir.pwd)
          File.join(Dir.pwd, '.sass-cache', 'bootstrap-email')
        else
          File.join(Dir.tmpdir, '.sass-cache', 'bootstrap-email')
        end
      end
    end

    def sass_log_enabled?
      defined?(@sass_log_enabled) ? @sass_log_enabled : true
    end
  end
end
