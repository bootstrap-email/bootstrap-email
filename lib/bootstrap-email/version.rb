module BootstrapEmail
  module Rails
    VERSION = File.read(
      File.expand_path('../../VERSION', __dir__)
    ).strip
  end
end
