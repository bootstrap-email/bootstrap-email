# frozen_string_literal: true

module BootstrapEmail
  class ConfigStore
    OPTIONS = [
      :sass_email_location, # path to main sass file
      :sass_head_location,  # path to head sass file
      :sass_load_paths,     # array of directories for loading sass imports
      :sass_cache_location, # path to tmp folder for sass cache
      :sass_log_enabled     # turn on or off sass log when caching new sass
    ].freeze

    attr_reader(*OPTIONS)

    OPTIONS.each do |option|
      define_method("#{option}=") do |value|
        instance_variable_set("@#{option}", value)
      end
    end

    def initialize(options = [])
      options.each { |name, value| instance_variable_set("@#{name}", value) if OPTIONS.include?(name) }
    end

    def did_set?(option)
      instance_variable_defined?("@#{option}")
    end
  end
end
