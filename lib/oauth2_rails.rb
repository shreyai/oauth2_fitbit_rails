require 'oauth2_rails/version'
require 'oauth2_rails/base'
require 'oauth2_rails/auth'
require 'oauth2_rails/errors'
require 'oauth2_rails/fitbit'
require 'oauth2_rails/response'
require 'oauth2_rails/user'
require 'faraday'
require 'base64'

module Oauth2Rails
  extend self
  def new(user, options = {})
    Client.new(user, options = {})
  end
end