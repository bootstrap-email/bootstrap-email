require_relative '../spec_helper'

describe 'bootstrapemail' do
  it 'builds the email without failing' do
    expect { system %{bootstrapemail -s '<a href="#" class="btn btn-primary">A very basic little button</a>'} }
     .to output(a_string_including('class="btn btn-primary"'))
     .to_stdout_from_any_process
  end
end
