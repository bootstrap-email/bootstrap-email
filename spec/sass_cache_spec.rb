# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe BootstrapEmail::SassCache do
  describe '#compile' do
    it 'is thread safe' do
      config = BootstrapEmail::Config.new

      10.times do
        threads = []
        FileUtils.rm_rf(Dir.glob("#{config.sass_cache_location}/*"))

        10.times do
          threads << Thread.new do
            css = BootstrapEmail::SassCache.compile('bootstrap-head', config)
            expect(css.length).not_to eq(0)
          end
        end

        threads.each(&:join)
      end
    end
  end
end
