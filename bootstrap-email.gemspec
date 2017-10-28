Gem::Specification.new do |s|
  s.name        = 'bootstrap-email'
  s.version     = '0.0.0'
  s.date        = '2017-10-28'
  s.summary     = "Bootstrap 4 style sheet and compiler for responsive and consistent emails."
  s.description = "Bootstrap 4 style sheet and compiler for responsive and consistent emails."
  s.authors     = ['Stuart Yamartino']
  s.email       = 'stuartyamartino@gmail.com'
  s.files       = ['lib/bootstrap-email.rb']
  s.homepage    = 'http://rubygems.org/gems/something'
  s.license     = 'MIT'

  s.add_runtime_dependency 'premailer-rails', '~> 1.9'

  s.add_development_dependency 'nokogiri'
  s.add_development_dependency 'actionmailer'
end
