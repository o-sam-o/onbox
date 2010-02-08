# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_onbox_session',
  :secret      => 'bc19f862eb20dc50da4358a270e387cc91595ba98ce75a0690ade8e2f4b96f69327c8ad5905f3a1e3578e826d29bc9ea97a5a1a8bebc3dc17510d0750f4a2e79'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
