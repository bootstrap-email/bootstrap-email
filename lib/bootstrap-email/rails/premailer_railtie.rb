class PremailerRailtie < Rails::Railtie
  initializer 'premailer_railtie.configure_rails_initialization' do
    Premailer::Rails.config.merge!(adapter: :nokogiri, preserve_reset: false, output_encoding: 'UTF-8')
  end
end
