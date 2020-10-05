class BootstrapEmailCLI < Thor
  desc 'compile PATH', 'compile files at a specific path'
  option :destination, aliases: '-d', desc: 'Destination of newly compiled files (default is /compiled)'
  def compile(path)

    puts options[:destination] if options[:destination]
    puts "Hello #{File.join(Dir.pwd, path)}"
  end
end
