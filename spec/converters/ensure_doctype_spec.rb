# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe BootstrapEmail::Converter::EnsureDoctype do
  describe '#replace' do
    it "adds a doctype when there isn't one" do
      html = <<~HTML
        <html>
          <head></head>
          <body>
          </body>
        </html>
      HTML
      doc = Nokogiri::HTML(html)
      html = doc.to_html(encoding: 'US-ASCII')
      BootstrapEmail::Converter::EnsureDoctype.replace(html)
      expect(html.scan('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">').one?).to eq(true)
    end

    it 'replaces the wrong doctype with the correct one' do
      html = <<~HTML
        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
        <html>
          <head></head>
          <body>
          </body>
        </html>
      HTML
      doc = Nokogiri::HTML(html)
      html = doc.to_html(encoding: 'US-ASCII')
      BootstrapEmail::Converter::EnsureDoctype.replace(html)
      expect(html.scan('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">').one?).to eq(true)
    end
  end
end
