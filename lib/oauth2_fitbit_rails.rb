require 'oauth2_fitbit_rails/version'
require 'oauth2_fitbit_rails/base'
require 'oauth2_fitbit_rails/auth'
require 'oauth2_fitbit_rails/errors'
require 'oauth2_fitbit_rails/fitbit'
require 'oauth2_fitbit_rails/response'
require 'oauth2_fitbit_rails/user'
require 'faraday'
require 'base64'

module Oauth2FitbitRails
  extend self
  def new(user, options = {})
    Client.new(user, options = {})
  end
end