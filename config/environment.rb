# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.load_paths << "#{RAILS_ROOT}/app/middleware"

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "shoulda"
  config.gem "factory_girl"
  config.gem "bcrypt-ruby", :lib => "bcrypt"
  config.gem "daemons"
  config.gem "haml"
  config.gem "formtastic"
  config.gem "rdiscount"
  config.gem "paperclip"
  config.gem "will_paginate"
  config.gem "delayed_job"
  config.gem "thinking-sphinx", :lib => "thinking_sphinx", :version => "1.3.16"
  config.gem "facebooker"
  config.gem "mime-types", :lib => "mime/types"
  config.gem "auto_html"
  config.gem "juggernaut"
  config.gem "json"
  config.gem "eventmachine"
  config.gem "fastercsv"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  config.active_record.observers = :plagg_observer, :offer_observer, :user_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end


ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => "secure813.hostgator.com",
  :port           => 26,
  :authentication => :login,
  :user_name      => "robot@pixelfuckers.org",
  :password       => "79spitfire"
}

ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.default_url_options[:host] = "plaggs.com"
LiveValidations.use :jquery_validations,:default_valid_message => ' ', :validate_on_blur => false

#recapcha keys
ENV['RECAPTCHA_PUBLIC_KEY']  = '6LcdXAwAAAAAANf-T4LLzSn4edNQhcAxce86w9F3'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6LcdXAwAAAAAAFpSi4CnatxeE9SxPD-bI7sQNuM-'
