require_relative '../lib/bootstrap-email'
require 'sassc'

def embed_in_layout(html)
  namespace = OpenStruct.new(contents: html)
  template_html = File.read(File.expand_path('layout.html.erb', __dir__))
  ERB.new(template_html).result(namespace.instance_eval { binding })
end

def run_tests
  puts 'Starting tests...'
  Dir.glob('tests/precompiled/*.html').each do |file|
    file_contents = File.read(file)
    compiled = BootstrapEmail::Compiler.new(type: :string, input: embed_in_layout(file_contents)).perform_full_compile
    destination = file.split('/').last
    File.write("tests/compiled/#{destination}", compiled)
    puts "Compiled #{destination}"
  end
  puts 'Finished compiling test files!'
end

run_tests
