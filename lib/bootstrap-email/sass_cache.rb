module BootstrapEmail
  class SassCache
    SASS_DIR = File.expand_path('../../core', __dir__)

    def self.compile(type, config_path: nil, style: :compressed)
      new(type, config_path, style).compile
    end

    attr_accessor :type, :style, :file_path, :config_file, :checksum

    def initialize(type, config_path, style)
      self.type = type
      self.style = style
      self.file_path = "#{SASS_DIR}/#{type}"
      self.config_file = load_config(config_path)
      self.checksum = checksum_files
    end

    def cache_dir
      @cache_dir ||= begin
        if defined?(::Rails) && ::Rails.root
          base_path = ::Rails.root.join('tmp')
        else
          base_path = Dir.pwd
        end
        File.join(base_path, '.sass-cache', 'bootstrap-email')
      end
    end

    def compile
      cache_path = "#{cache_dir}/#{checksum}/#{type}.css"
      unless cached?(cache_path)
        compile_and_cache_scss(cache_path)
      end
      File.read(cache_path)
    end

    private

    def load_config(config_path)
      lookup_locations = ["#{type}.config.scss", "app/assets/stylesheets/#{type}.config.scss"]
      locations = lookup_locations.select { |location| File.exist?(File.expand_path(location, Dir.pwd)) }
      if config_path && File.exist?(config_path)
        # check if custom config was passed in
        replace_config(File.read(config_path))
      elsif locations.any?
        # look for common lookup locations of config
        replace_config(File.read(File.expand_path(locations.first, Dir.pwd)))
      end
    end

    def replace_config(config_file)
      config_file.gsub("//= @import #{type};", "@import '#{file_path}';")
    end

    def checksum_files
      checksums = config_file.nil? ? [] : [Digest::SHA1.hexdigest(config_file)]
      Dir.glob('../../core/**/*.scss', base: __dir__).each do |path|
        checksums << Digest::SHA1.file(File.expand_path(path, __dir__)).hexdigest
      end
      Digest::SHA1.hexdigest(checksums.join)
    end

    def cached?(cache_path)
      File.file?(cache_path)
    end

    def compile_and_cache_scss(cache_path)
      file = config_file || File.read("#{file_path}.scss")
      css = SassC::Engine.new(file, style: style).render
      FileUtils.mkdir_p("#{cache_dir}/#{checksum}") unless File.directory?("#{cache_dir}/#{checksum}")
      File.write(cache_path, css)
      puts "New css file cached for #{type}"
    end
  end
end
