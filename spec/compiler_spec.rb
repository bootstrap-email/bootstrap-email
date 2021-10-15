require_relative 'spec_helper'

RSpec.describe BootstrapEmail::Compiler do
  describe '#purged_css_from_head' do
    it 'purges all padding utils from the <head> but two: p-4 & p-5' do
      html = <<~HTML
        <p>Test</p>
        <table class="p-4">
          <tbody>
            <tr>
              <td>Give me padding!</td>
            </tr>
          </tbody>
        </table>
        <!-- The trick here is the .btn is included in padding selectors for specific btn padding -->
        <!-- The .btn class was a culprit for not purging all padding selectors originally since they all contained the .htn in the selector -->
        <a class="btn p-5" href="#">Some button</a>
      HTML
      output = BootstrapEmail::Compiler.new(html).perform_full_compile
      doc = Nokogiri::HTML(output)
      head = doc.at_css('head').to_s
      head.include?('p-4')

      expect(head.include?('p-4')).to be true
      expect(head.include?('p-5')).to be true
      expect(head.include?('p-6')).to be false
    end
  end

  describe '.align' do
    it 'creates an html table with the "align" property set on it' do
      html = <<~HTML
        <div class="wrapper-1">
          <a class="btn ax-center" href="#">Cool</a>
        </div>
        <div class="wrapper-2">
          <img class="w-10 ax-right" src="#" />
        </div>
      HTML
      output = BootstrapEmail::Compiler.new(html).perform_full_compile
      doc = Nokogiri::HTML(output)
      expect(doc.at_css('.wrapper-1 .ax-center')).to be_truthy
      expect(doc.at_css('.wrapper-1 .ax-center').attr('align')).to eq('center')
      expect(doc.at_css('.wrapper-2 .ax-right')).to be_truthy
      expect(doc.at_css('.wrapper-2 .ax-right').attr('align')).to eq('right')
    end
  end

  describe '.spacing' do
    it 'creates an vertical spacer between each child' do
      html = <<~HTML
        <div class="card space-y-8">
          <div>
            <p>Some other nested child here that shouln't affect it</p>
          </div>
          <div></div>
          <div></div>
        </div>
        <div class="space-y-6">
          <div>
            <p>Some other nested child here that shouln't affect it</p>
          </div>
          <div></div>
          <div></div>
        </div>
      HTML
      output = BootstrapEmail::Compiler.new(html).perform_full_compile
      doc = Nokogiri::HTML(output)
      expect(doc.css('.s-6').count).to eq(2)
      expect(doc.css('.s-8').count).to eq(2)
    end
  end

  describe '.card' do
    it 'creates a card and removes the wrapping div' do
      html = <<~HTML
        <div class="card">
          Hello
        </div>
      HTML
      output = BootstrapEmail::Compiler.new(html).perform_full_compile
      doc = Nokogiri::HTML(output)
      expect(doc.at_css('.card').parent.name).not_to eq('div')
      expect(doc.at_css('.card').children.first.name).not_to eq('div')
    end
  end

  describe '#compile' do
    it 'does not strip tokens from href urls' do
      html = <<~HTML
        <div id="test1">{{ test1_token }}</div>
        <a id="test2" href="{{ test2_token }}">Some Token Link</a>
        <a id="test3" href="https://google.com/some+url{{">Some Link with regular url to be encoded</a>
        <img id="test4" src="{{ test4_image_src }}" />
      HTML
      output = BootstrapEmail::Compiler.new(html).perform_full_compile
      doc = Nokogiri::HTML(output)
      expect(doc.at_css('#test1').inner_html).to eq('{{ test1_token }}')
      expect(doc.at_css('#test2')['href']).to eq('{{ test2_token }}')
      expect(doc.at_css('#test3')['href']).to eq('https://google.com/some+url%7B%7B')
      expect(doc.at_css('#test4')['src']).to eq('{{ test4_image_src }}')
    end
  end

  describe '#compile' do
    it 'forces the encoding of the email' do
      output = BootstrapEmail::Compiler.new('<body>➿</body>').perform_full_compile
      expect(output.include?('&#10175;')).to be true
      expect(output.include?('content="text/html; charset=utf-8')).to be true
      expect(output.exclude?('content="text/html; charset=US-ASCII"')).to be true
    end
  end
end
