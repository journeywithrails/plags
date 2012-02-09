# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_plaggs_session',
  :secret      => '6d7a4141ec97507b8d9d74ea033775a8c75fa82f373feb09fc8bceb8fc907db261be2dcbdc0bf8e6c448fbbe49ae7918d3739ffe32c27e2d0506e19386b35be6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

ActionController::Dispatcher.middleware.insert_before(
  ActionController::Session::CookieStore,
  FlashSessionCookieMiddleware,
  ActionController::Base.session_options[:key]
)