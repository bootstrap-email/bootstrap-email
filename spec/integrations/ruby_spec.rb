require_relative '../spec_helper'

describe 'BootstrapEmail::Compiler#perform_full_compile' do
  it 'builds the email without failing' do
    file_contents = '<a href="#" class="btn btn-primary">A very basic little button</a>'
    BootstrapEmail::Compiler.new(type: :string, input: file_contents).perform_full_compile
  end
end
