# frozen_string_literal: true

module BootstrapEmail
  VERSION = File.read(
    File.expand_path('../../VERSION', __dir__)
  ).strip.freeze
end
