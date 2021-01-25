require_relative '../spec_helper'

describe 'ActionMailer#bootstrap_mail' do
  it 'builds the email without failing' do
    WelcomeMailer.welcome_email('world').deliver_now
  end

  it 'delivers an inlined email' do
    WelcomeMailer.welcome_email('world').deliver_now

    mail = ActionMailer::Base.deliveries.last
    expect(mail).to be_present
    body = (mail.html_part || mail).body.to_s
    expect(body).to be_present
    expect(body).to include(%{<p class="" style="line-height: 24px; font-size: 16px; width: 100%; -premailer-width: 100%; margin: 0;" align="left">Hello world</p>})
  end
end
