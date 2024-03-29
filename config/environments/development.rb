require 'wicked_pdf'

Showtime::Application.configure do
  # config.middleware.use WickedPdf::Middleware, {margin: {top: 0, left: 0, bottom: 0, right: 0}}

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

  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.default_url_options = {:host => ENV['HOST']}
  config.action_mailer.asset_host = "http://#{ENV['HOST']}"

  default_url_options = { :host => ENV['HOST'] }
  config.default_url_options = { :host => ENV['HOST'] }
  routes.default_url_options = { :host => ENV['HOST'] }
  config.action_controller.asset_host = ENV['HOST']

  # WashOut configuration
  config.wash_out.snakecase_input = true
  config.wash_out.camelize_wsdl = true
end
