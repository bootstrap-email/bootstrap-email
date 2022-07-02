# frozen_string_literal: true

module BootstrapEmail
  class ConfigStore
    OPTIONS = [
      :sass_email_location,     # path to main sass file
      :sass_head_location,      # path to head sass file
      :sass_email_string,       # main sass file passed in as a string
      :sass_head_string,        # head sass file passed in as a string
      :sass_load_paths,         # array of directories for loading sass imports
      :sass_cache_location,     # path to tmp folder for sass cache
      :sass_log_enabled,        # turn on or off sass log when caching new sass
      :generate_rails_text_part # boolean for whether or not to generate the text part in rails, default: true
    ].freeze

    attr_accessor(*OPTIONS)

    def initialize(options = [])
      defaults
      options.each { |name, value| instance_variable_set("@#{name}", value) if OPTIONS.include?(name) }
    end

    def did_set?(option)
      instance_variable_defined?("@#{option}")
    end

    private

    def defaults
      self.generate_rails_text_part = true
    end
  end
end
