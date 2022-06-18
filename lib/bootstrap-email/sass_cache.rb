# frozen_string_literal: true

module BootstrapEmail
  class SassCache
    SASS_DIR = File.expand_path('../../core', __dir__)

    def self.compile(type, config, style: :compressed)
      new(type, config, style).compile
    end

    attr_accessor :type, :config, :style, :file_path, :sass_config, :checksum, :cache_dir

    def initialize(type, config, style)
      self.type = type
      self.config = config
      self.style = style
      self.file_path = "#{SASS_DIR}/#{type}"
      self.sass_config = load_sass_config
      self.checksum = checksum_files
      self.cache_dir = config.sass_cache_location
    end

    def compile
      cache_path = "#{cache_dir}/#{checksum}/#{type}.css"
      compile_and_cache_scss(cache_path) unless cached?(cache_path)
      File.read(cache_path)
    end

    private

    def load_sass_config
      sass_string = config.sass_string_for(type: type)
      replace_config(sass_string) if sass_string
    end

    def replace_config(sass_config)
      sass_config.gsub("//= @import #{type};", "@import '#{file_path}';")
    end

    def checksum_files
      checksums = sass_config.nil? ? [] : [Digest::SHA1.hexdigest(sass_config)]
      config.sass_load_paths.each do |load_path|
        Dir.glob(File.join(load_path, '**', '*.scss'), base: __dir__).each do |path|
          checksums << Digest::SHA1.file(File.expand_path(path, __dir__)).hexdigest
        end
      end

      Digest::SHA1.hexdigest(checksums.join)
    end

    def cached?(cache_path)
      File.file?(cache_path)
    end

    def compile_and_cache_scss(cache_path)
      file = sass_config || File.read("#{file_path}.scss")
      css = SassC::Engine.new(file, style: style).render
      FileUtils.mkdir_p("#{cache_dir}/#{checksum}") unless File.directory?("#{cache_dir}/#{checksum}")
      File.write(cache_path, css)
      puts "New css file cached for #{type}" if config.sass_log_enabled?
    end
  end
end
