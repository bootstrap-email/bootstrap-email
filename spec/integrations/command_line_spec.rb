# frozen_string_literal: true

require_relative '../spec_helper'

describe 'bootstrap-email' do
  it 'builds the email from a path and saves it in a directory' do
    expect(File.exist?('spec/html/output/button.html')).to be false
    expect { system %(bootstrap-email -p 'spec/html/*' -d 'spec/html/output/*' ) }
      .to output(a_string_including('Compiling file spec/html/button.html'))
      .to_stdout_from_any_process
    expect(File.exist?('spec/html/output/button.html')).to be true
  end

  it 'builds the email from a string without failing' do
    expect { system %(bootstrap-email -s '<a href="#" class="btn btn-primary">A very basic little button</a>') }
      .to output(a_string_including('class="btn btn-primary"'))
      .to_stdout_from_any_process
  end

  it 'builds the email from a file without failing' do
    expect { system %(bootstrap-email spec/html/button.html ) }
      .to output(a_string_including('class="btn btn-primary"'))
      .to_stdout_from_any_process
  end

  it 'builds the email from a file and does not print sass log' do
    BootstrapEmail.configure do |config|
      config.sass_cache_location = File.join(Dir.pwd, '.sass-cache', 'bootstrap-email')
    end
    BootstrapEmail.clear_sass_cache!
    expect { system %(bootstrap-email spec/html/button.html ) }
      .to_not output(a_string_including('New css file cached for'))
      .to_stdout_from_any_process
    BootstrapEmail.reset_config!
  end
end
