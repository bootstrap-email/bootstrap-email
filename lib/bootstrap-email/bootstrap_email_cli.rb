class BootstrapEmailCLI < Thor
  desc 'compile PATH', 'compile files at a specific path'
  option :output, aliases: '-o', desc: 'Destination of newly compiled files (default is /output)'
  def compile(path)
    puts "Compiling file at #{File.join(Dir.pwd, path)}"
    compiled = BootstrapEmail::Compiler.new(type: :file, input: File.join(Dir.pwd, path)).perform_full_compile
    if options[:output]
      File.write(File.join(Dir.pwd, options[:output]), compiled)
    else
      compiled
    end
  end
end
