require_relative 'lib/bootstrap-email'
require 'action_mailer'
require './sassc'
require 'ostruct'

class TestMailer < ActionMailer::Base
  def build(body)
    mail = mail(
      to: 'info@bootstrapemail.com',
      subject: 'test',
      body: body,
      content_type: 'text/html'
    )

    bootstrap = BootstrapEmail::Compiler.new(mail)
    bootstrap.perform_full_compile
  end
end

def compile_css
  sass = SassC::Engine.new(File.read(File.expand_path('core/bootstrap-email.scss', __dir__)), syntax: :scss, style: :compressed, cache: false, read_cache: false).render
  File.write('test/bootstrap-email.css', sass)
end

def embed_in_layout(html)
  namespace = OpenStruct.new(contents: html)
  template_html = File.read(File.expand_path('tests/layout.html.erb', __dir__))
  ERB.new(template_html).result(namespace.instance_eval { binding })
end

def run_tests
  Dir.glob('test/preinlined/*.html').each do |file|
    file_contents = File.read(file)
    compiled = TestMailer.build(embed_in_layout(file_contents)).html_part.body.raw_source
    destination = file.split('/').last
    File.write("test/inlined/#{destination}", compiled)
  end
end

compile_css
