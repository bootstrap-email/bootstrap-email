require_relative '../lib/bootstrap_email'
require 'rspec'

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
      output = BootstrapEmail::Compiler.new(type: :string, input: html).perform_full_compile
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
          <a class="btn align-center" href="#">Cool</a>
        </div>
        <div class="wrapper-2">
          <img class="w-10 align-right" src="#" />
        </div>
      HTML
      output = BootstrapEmail::Compiler.new(type: :string, input: html).perform_full_compile
      doc = Nokogiri::HTML(output)
      expect(doc.at_css('.wrapper-1 .align-center')).to be_truthy
      expect(doc.at_css('.wrapper-1 .align-center').attr('align')).to eq('center')
      expect(doc.at_css('.wrapper-2 .align-right')).to be_truthy
      expect(doc.at_css('.wrapper-2 .align-right').attr('align')).to eq('right')
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
      output = BootstrapEmail::Compiler.new(type: :string, input: html).perform_full_compile
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
      output = BootstrapEmail::Compiler.new(type: :string, input: html).perform_full_compile
      doc = Nokogiri::HTML(output)
      expect(doc.css('div').count).to eq(0)
    end
  end
end
