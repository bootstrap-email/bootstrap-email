module BootstrapEmail
  class << self
    def config
      @config ||= Config.new
      @config
    end

    def config=(data)
      @config ||= Config.new(data)
      @config
    end

    def configure(&proc)
      @config ||= Config.new
      yield @config
    end
  end
end
