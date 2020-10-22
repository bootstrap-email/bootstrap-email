ActiveSupport.on_load(:action_mailer, {yield: true}) do |action_mailer|
  action_mailer.class_eval do # To support Rails less than 6
    # sit in the middle and compile the html
  def bootstrap_mail(*args, &block)
    bootstrap = BootstrapEmail::Compiler.new(mail(*args, &block))
    bootstrap.perform_full_compile
  end
  alias make_bootstrap_mail bootstrap_mail
end
