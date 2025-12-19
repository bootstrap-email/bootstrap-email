# frozen_string_literal: true

require_relative '../spec_helper'

describe 'BootstrapEmail::Compiler#perform_full_compile' do
  it 'processed the same emails with different sass defaults passed in' do
    html = <<~HTML
      <a href="https://bootstrapemail.com" class="btn btn-primary">Test</a>
    HTML

    sass_string = <<~SCSS
      // Override primary color to black
      $primary: #000000;

      //= @import bootstrap-email;
    SCSS

    output1 = BootstrapEmail::Compiler.new(html).perform_full_compile
    output2 = BootstrapEmail::Compiler.new(html, options: { sass_email_string: sass_string }).perform_full_compile

    expect(Nokogiri::HTML(output1).at_css('a').attr('style')).to include('background-color: #0D6EFD;')
    expect(Nokogiri::HTML(output2).at_css('a').attr('style')).to include('background-color: #000000;')
  end
end
