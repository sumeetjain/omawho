require 'development_mail_interceptor'

ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['SENDGRID_USERNAME'],
  :password       => ENV['SENDGRID_PASSWORD'],
  :domain         => 'heroku.com'
}
ActionMailer::Base.delivery_method ||= :smtp
ActionMailer::Base.default_url_options[:host] = ENV['MAIL_HOST_URL'] || "localhost:5000"
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?