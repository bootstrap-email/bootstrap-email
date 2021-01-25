module BootstrapEmail
  class SassCache
    CACHE_DIR = File.expand_path('../../.sass-cache', __dir__)
    SASS_DIR = File.expand_path('../../core', __dir__)

    def self.compile(name, config_path: nil, style: :compressed)
      path = "#{SASS_DIR}/#{name}"
      config_file = nil

      lookup_locations = ["#{name}.config.scss", "app/assets/stylesheets/#{name}.config.scss"]
      locations = lookup_locations.select { |location| File.exist?(File.expand_path(location, Dir.pwd)) }

      if config_path && File.exist?(config_path)
        # check if custom config was passed in
        config_file = File.read(config_path)
      elsif locations.any?
        config_file = File.read(File.expand_path(locations.first, Dir.pwd))
      end

      check = checksum(config_file&.gsub("//= @import #{name};", "@import '#{path}';"))
      cache_path = "#{CACHE_DIR}/#{check}/#{name}.css"
      if cached?(cache_path)
        File.read(cache_path)
      else
        file = config_file.nil? ? File.read("#{path}.scss") : config_file
        SassC::Engine.new(file, style: style).render.tap do |css|
          Dir.mkdir(CACHE_DIR) unless File.directory?(CACHE_DIR)
          Dir.mkdir("#{CACHE_DIR}/#{check}") unless File.directory?("#{CACHE_DIR}/#{check}")
          File.write(cache_path, css)
          puts "New css file cached for #{name}"
        end
      end
    end

    def self.checksum(config_file)
      checksums = config_file.nil? ? [] : [Digest::SHA1.hexdigest(config_file)]
      Dir.glob('../../core/**/*.scss', base: __dir__).each do |path|
        checksums << Digest::SHA1.file(File.expand_path(path, __dir__)).hexdigest
      end
      Digest::SHA1.hexdigest(checksums.join)
    end

    def self.cached?(cache_path)
      File.file?(cache_path)
    end
  end
end
