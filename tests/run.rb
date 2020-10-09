require_relative '../lib/bootstrap_email'

start_time = Time.now
puts '🧪 Starting tests...'
Dir.glob('tests/input/**/*.html*').each do |file|
  start_file_time = Time.now
  file_contents = ERB.new(File.read(file)).result
  compiled = BootstrapEmail::Compiler.new(type: :string, input: file_contents).perform_full_compile
  destination = file.sub('tests/input/', '').sub('.erb', '')
  File.write("tests/output/#{destination}", compiled)
  puts "🚀 Built #{destination} (in #{(Time.now - start_file_time).truncate(2)}s)"
end
puts "Finished compiling tests in #{(Time.now - start_time).truncate(2)}s 🎉"

# manually run cli command to test bin/bootstrapemail compile precompiled/components/alert.html -d
