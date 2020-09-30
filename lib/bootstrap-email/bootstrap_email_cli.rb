class BootstrapEmailCLI < Thor
  desc 'compile PATH', 'compile files at a specific path'
  def compile(path)
    puts "Hello #{File.join(Dir.pwd, path)}"
  end
end
