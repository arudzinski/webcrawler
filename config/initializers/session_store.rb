# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_domain_crawler_session',
  :secret      => '7574cf9822cde14ec202b25aa0441fda820caba84dea5e383d3ecf80e24b23fcae13bfe89e17afc7b20bd841c12e120b06291bde5a67462767117e19b74bc8a4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
