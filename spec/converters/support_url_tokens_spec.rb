require_relative '../spec_helper'

RSpec.describe BootstrapEmail::Converter::SupportUrlTokens do
  describe '#replace' do
    it 'supports {{ tokens in src and hrefs' do
      html = <<~HTML
        <html>
          <head></head>
          <body>
            <img src="{{ some_code_here }}">
            <a href="{{ some_code_here }}">Link</a>
          </body>
        </html>
      HTML
      doc = Nokogiri::HTML(html)
      html = doc.to_html(encoding: 'US-ASCII')
      BootstrapEmail::Converter::SupportUrlTokens.replace(html)
      expect(html.scan('<img src="{{ some_code_here }}">').one?).to eq(true)
      expect(html.scan('<a href="{{ some_code_here }}">Link</a>').one?).to eq(true)
    end

    it 'supports {{ tokens before, after, and between in src and hrefs' do
      html = <<~HTML
        <html>
          <head></head>
          <body>
            <img src="https://example.com/{{ some_code_here }}">
            <a href="{{ some_code_here }}/example/com">Link</a>
            <img src="https://example.com/{{ some_code_here }}/example/com">
          </body>
        </html>
      HTML
      doc = Nokogiri::HTML(html)
      html = doc.to_html(encoding: 'US-ASCII')
      BootstrapEmail::Converter::SupportUrlTokens.replace(html)
      expect(html.scan('<img src="https://example.com/{{ some_code_here }}">').one?).to eq(true)
      expect(html.scan('<a href="{{ some_code_here }}/example/com">Link</a>').one?).to eq(true)
      expect(html.scan('<img src="https://example.com/{{ some_code_here }}/example/com">').one?).to eq(true)
    end
  end
end
