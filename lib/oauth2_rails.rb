require 'oauth2_rails/version'
require 'faraday'

module Oauth2Rails
  extend self
  def new
    Client.new()
  end
end