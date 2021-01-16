require_relative 'spec_helper'

describe 'bootstrap_mail' do
  it 'builds the email without failing' do
    WelcomeMailer.welcome_email("world").deliver_now
  end

  it 'delivers an inlined email' do
    WelcomeMailer.welcome_email("world").deliver_now

    mail = ActionMailer::Base.deliveries.last
    expect(mail).to be_present
    body = mail.html_part.body.to_s
    expect(body).to be_present
    expect(body).to include(%{<p style="font-size: 12px;">Hello world</p>})
  end
end
