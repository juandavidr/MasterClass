# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_generate_session',
  :secret      => '397466afe211f4747b5ef4f07b77dd4e4741de1aa249de1653a4d9db982405d5ac8071b976f3561fb3b263a31d4f049dcd5c8e6e0b8bf0c2075ade0d244ac250'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
