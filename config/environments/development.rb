Omawho::Application.configure do
  # http://stackoverflow.com/questions/8031007/
  # how-to-increase-heroku-log-drain-verbosity-to-include-all-rails-app-details/8075630#8075630
  STDOUT.sync = true
  logger = Logger.new(STDOUT)
  logger.level = 0 # Must be numeric here - 0 :debug, 1 :info, 2 :warn, 3 :error, and 4 :fatal
  # NOTE:   with 0 you're going to get all DB calls, etc.
  Rails.logger = Rails.application.config.logger = logger
  
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
end
