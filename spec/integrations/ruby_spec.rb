# frozen_string_literal: true

require_relative '../spec_helper'

describe 'BootstrapEmail::Compiler#perform_full_compile' do
  it 'builds the email without failing' do
    html = '<a href="#" class="btn btn-primary">A very basic little button</a>'
    BootstrapEmail::Compiler.new(html).perform_full_compile
  end
end
