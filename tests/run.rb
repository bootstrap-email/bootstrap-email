require_relative '../lib/bootstrap_email'
require 'sassc'

def embed_in_layout(html)
  namespace = OpenStruct.new(contents: ERB.new(html).result)
  template_html = File.read(File.expand_path('layout.html.erb', __dir__))
  ERB.new(template_html).result(namespace.instance_eval { binding })
end

start_time = Time.now
puts 'Starting tests...'
Dir.glob('tests/precompiled/**/*.html*').each do |file|
  file_contents = embed_in_layout(File.read(file))
  compiled = BootstrapEmail::Compiler.new(type: :string, input: file_contents).perform_full_compile
  destination = file.sub('tests/precompiled/', '').sub('.erb', '')
  File.write("tests/compiled/#{destination}", compiled)
  puts "Compiled #{destination}"
end
puts "Finished compiling tests in #{(Time.now - start_time).truncate(2)}s!"
