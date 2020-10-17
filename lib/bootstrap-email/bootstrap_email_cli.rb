require_relative '../bootstrap_email'
require 'optparse'
require 'fileutils'

input = nil
options = {
  destination: 'output',
  type: :file
}

parser = OptionParser.new do |opts|
  opts.banner = "Bootstrap 5 stylesheet, compiler, and inliner for responsive and consistent emails with the Bootstrap syntax you know and love.\n\n"
  opts.define_head 'Usage: bootstrapemail <path> [options]'
  opts.separator ''
  opts.separator 'Examples:'
  opts.separator '  bootstrapemail email.html > out.html'
  opts.separator '  bootstrapemail ./public/index.html'
  opts.separator "  bootstrapemail -p 'emails/*' -d emails/output"
  opts.separator "  bootstrapemail -p 'views/emails/*' -d 'views/compiled_emails'"
  opts.separator '  cat input.html | bootstrapemail'
  opts.separator ''
  opts.separator 'Options:'

  opts.on('-s', '--string STRING', String, 'HTML string to be to be compiled rather than a file.') do |v|
    input = v
    options[:type] = :string
  end

  opts.on('-p', '--pattern STRING', String, 'Specify a pattern of files to compile and save multiple files at once.') do |v|
    input = v
    options[:type] = :pattern
  end

  opts.on('-d', '--destination STRING', String, 'Destination for compiled files (used with the --pattern option).') do |v|
    options[:destination] = v
  end

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end

  opts.on('-v', '--version', 'Show version') do
    puts BootstrapEmail::VERSION
    exit
  end
end
parser.parse!

if input
  # input already set by pattern
elsif ARGV.any?
  # Executed via command line or shell script
  input = ARGV.shift
else
  # Called in piped command
  input = $stdin.read
  options[:type] = :string
end

if input
  case options[:type]
  when :pattern
    Dir.glob(input, base: Dir.pwd).each do |path|
      next unless File.file?(path)

      puts "Compiling file at #{path}."
      compiled = BootstrapEmail::Compiler.new(type: :file, input: path).perform_full_compile
      FileUtils.mkdir_p("#{Dir.pwd}/#{options[:destination]}")
      File.write(File.expand_path("#{options[:destination]}/#{path.split('/').last}", Dir.pwd), compiled)
    end
  when :file
    path = File.expand_path(input, Dir.pwd)
    puts BootstrapEmail::Compiler.new(type: :string, input: File.join(Dir.pwd, path)).perform_full_compile
  when :string
    puts BootstrapEmail::Compiler.new(type: :string, input: input).perform_full_compile
  end
else
  puts opts
  exit 1
end
