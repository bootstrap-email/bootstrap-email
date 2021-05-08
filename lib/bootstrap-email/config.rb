module BootstrapEmail
  class Config
    # path to sass file
    # path to sass load path
    # path to tmp folder for sass cache
    # disable sass cache log?
    attr_writer :sass_email_location
    attr_writer :sass_head_location
    attr_writer :sass_load_paths
    attr_writer :sass_cache_location

    def load_options(options)
      options.each { |name, value| instance_variable_set("@#{name}", value) }
    end

    def sass_location_for(type:)
      ivar = instance_variable_get("@sass_#{type.sub('bootstrap-', '')}_location")
      return ivar if ivar

      lookup_locations = ["#{type}.config.scss", "app/assets/stylesheets/#{type}.config.scss"]
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
  end
end
