module BootstrapEmail
  class SassCache
    CACHE_DIRECTORY = File.expand_path('../../.sass-cache', __dir__)

    def self.compile(path, style: :compressed)
      check = checksum
      cache_path = "#{CACHE_DIRECTORY}/#{check}/#{path.split('/').last.sub('.scss', '.css')}"
      if cached?(cache_path)
        File.read(cache_path)
      else
        SassC::Engine.new(File.read(path), style: style).render.tap do |css|
          Dir.mkdir(CACHE_DIRECTORY) unless File.directory?(CACHE_DIRECTORY)
          Dir.mkdir("#{CACHE_DIRECTORY}/#{check}") unless File.directory?("#{CACHE_DIRECTORY}/#{check}")
          File.write(cache_path, css)
        end
      end
    end

    def self.checksum
      file_checksums = Dir.glob('core/**/*.scss').map do |path|
        Digest::SHA1.file(path).hexdigest
      end
      Digest::SHA1.hexdigest(file_checksums.join)
    end

    def self.cached?(cache_path)
      File.file?(cache_path)
    end
  end
end
