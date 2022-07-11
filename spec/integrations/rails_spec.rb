# frozen_string_literal: true

require_relative '../spec_helper'

describe 'ActionMailer#bootstrap_mail' do
  it 'builds the email without failing' do
    BootstrapEmail.configure do |config|
      config.sass_email_location = File.expand_path('../rails_app/app/assets/stylesheets/bootstrap-email.config.scss', __dir__)
      config.sass_load_paths = [File.expand_path('../rails_app/app/assets/stylesheets', __dir__)]
    end
    WelcomeMailer.welcome_email('world').deliver_now
    BootstrapEmail.reset_config!
  end

  it 'delivers an inlined email' do
    WelcomeMailer.welcome_email('world').deliver_now

    mail = ActionMailer::Base.deliveries.last
    expect(mail).to be_present
    body = (mail.html_part || mail).body.to_s
    expect(body).to be_present
    expect(body).to include(%(<p style="line-height: 24px; font-size: 16px; width: 100%; margin: 0;" align="left">Hello world</p>))
  end

  it 'delivers a multipart email' do
    WelcomeMailer.welcome_email('world').deliver_now

    mail = ActionMailer::Base.deliveries.last
    expect(mail).to be_present
    html = mail.html_part.decoded
    expect(html).to be_present
    expect(html).to include(%(<p style="line-height: 24px; font-size: 16px; width: 100%; margin: 0;" align="left">Hello world</p>))
    text = mail.text_part.decoded
    expect(text).to be_present
    expect(text).to eq 'Hello world'
  end

  it 'turns off support for text parts in emails' do
    BootstrapEmail.configure do |config|
      config.generate_rails_text_part = false
    end
    WelcomeMailer.welcome_email('world').deliver_now

    mail = ActionMailer::Base.deliveries.last
    expect(mail).to be_present
    html = mail.body.to_s
    expect(html).to be_present
    expect(mail.content_type).to include('text/html')
    text = mail.text_part
    expect(text).to be_nil
  end
end
