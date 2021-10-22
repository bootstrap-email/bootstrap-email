require_relative 'spec_helper'

RSpec.describe BootstrapEmail::Converter::Base do
  describe '#add_class' do
    it 'removes all extra spaces regardless of input' do
      html = <<~HTML
        <div class=" some class    lots-of-spaces"></div>
      HTML
      doc = Nokogiri::HTML(html)
      converter = BootstrapEmail::Converter::Base.new(doc)
      el = doc.at_css('div')
      converter.send(:add_class, el, '   other   things lots of   more spaces')

      expect(el['class']).to eq('some class lots-of-spaces other things lots of more spaces')
    end
  end
end
