module BootstrapEmail
  class SassCache
    SASS_DIR = File.expand_path('../../core', __dir__)

    def self.compile(type, style: :compressed)
      new(type, style).compile
    end

    attr_accessor :type, :style, :file_path, :config_file, :checksum

    def initialize(type, style)
      self.type = type
      self.style = style
      self.file_path = "#{SASS_DIR}/#{type}"
      self.config_file = load_config
      self.checksum = checksum_files
    end

    def cache_dir
      BootstrapEmail.config.sass_cache_location
    end

    def compile
      cache_path = "#{cache_dir}/#{checksum}/#{type}.css"
      compile_and_cache_scss(cache_path) unless cached?(cache_path)
      File.read(cache_path)
    end

    private

    def load_config
      path = BootstrapEmail.config.sass_location_for(type: type)
      replace_config(File.read(path)) if path
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
      puts "New css file cached for #{type}" if BootstrapEmail.config.sass_log_enabled?
    end
  end
end
