require 'oauth2_rails/version'
require 'faraday'
require 'base64'

module Oauth2Rails
  extend self
  def new(user, options = {})
    Client.new(user, options = {})
  end
end