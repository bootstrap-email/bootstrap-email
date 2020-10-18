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
        <a class="btn p-5" href="#">Some buttobn</a>
      HTML
      output = BootstrapEmail::Compiler.new(type: :string, input: html).perform_full_compile
      # puts output
      doc = Nokogiri::HTML(output)
      head = doc.at_css('head').to_s
      head.include?('p-4')

      expect(head.include?('p-4')).to be true
      expect(head.include?('p-5')).to be true
      expect(head.include?('p-6')).to be false
    end
  end
end
