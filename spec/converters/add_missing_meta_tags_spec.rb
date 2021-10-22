require_relative '../spec_helper'

RSpec.describe BootstrapEmail::Converter::AddMissingMetaTags do
  describe '#build' do
    it 'adds all missing meta tags' do
      html = <<~HTML
        <html>
          <head></head>
          <body></body>
        </html>
      HTML
      doc = Nokogiri::HTML(html)
      BootstrapEmail::Converter::AddMissingMetaTags.build(doc)

      html = doc.to_html
      expect(html.scan('<meta http-equiv="Content-Type" content="text/html; charset=utf-8">').one?).to eq(true)
      expect(html.scan('<meta http-equiv="x-ua-compatible" content="ie=edge">').one?).to eq(true)
      expect(html.scan('<meta name="x-apple-disable-message-reformatting">').one?).to eq(true)
      expect(html.scan('<meta name="viewport" content="width=device-width, initial-scale=1">').one?).to eq(true)
      expect(html.scan('<meta name="format-detection" content="telephone=no, date=no, address=no, email=no">').one?).to eq(true)
    end

    it 'adds only one missing meta tags' do
      html = <<~HTML
        <html>
          <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <meta name="x-apple-disable-message-reformatting">
            <meta name="viewport" content="width=device-width, initial-scale=1">
          </head>
          <body></body>
        </html>
      HTML
      doc = Nokogiri::HTML(html)
      BootstrapEmail::Converter::AddMissingMetaTags.build(doc)

      html = doc.to_html
      expect(html.scan('<meta http-equiv="Content-Type" content="text/html; charset=utf-8">').one?).to eq(true)
      expect(html.scan('<meta http-equiv="x-ua-compatible" content="ie=edge">').one?).to eq(true)
      expect(html.scan('<meta name="x-apple-disable-message-reformatting">').one?).to eq(true)
      expect(html.scan('<meta name="viewport" content="width=device-width, initial-scale=1">').one?).to eq(true)
      expect(html.scan('<meta name="format-detection" content="telephone=no, date=no, address=no, email=no">').one?).to eq(true)
    end
  end
end
