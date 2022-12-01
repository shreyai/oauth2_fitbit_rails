require 'oauth2_fitbit_rails/errors'

module Oauth2FitbitRails
  class Base

    def initialize(options = {})
      @oauth_id       = options[:oauth_id]       || '239359'
      @oauth_secret   = options[:oauth_secret]   || 'a22305522c49e899c589ef6ce87c0c14'
      @redirect_uri   = options[:redirect_uri]   || 'https://ddd3-2405-201-300b-70fb-12a5-77bc-f040-d73c.ngrok.io/auth/fitbit_oauth2/callback'
      @authorize_path = options[:authorize_path] || '/oauth2/authorize'
      @api_site       = options[:api_site]       || 'https://api.fitbit.com'
      @token_path     = options[:token_path]     || '/oauth2/token'
      @scope          = options[:scope]          || 'activity profile'
    end

    def connection(url)
      Faraday.new(url: url) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
    end

    def call(action, destination, options = {})
      user = options[:user]
      site = options[:site] || @api_site

      if user
        auth_header = "Bearer #{user}"
      else
        encoded = Base64.strict_encode64("#{@oauth_id}:#{@oauth_secret}")
        auth_header = "Basic #{encoded}"
      end

      call = connection(site).send(action) do |req|
        req.url destination
        req.headers['Content-Type']   = 'application/x-www-form-urlencoded'
        req.headers['Authorization']  = auth_header
        req.body = options[:body]
      end

      response = Response.new(call)
      case response.status
        when 400 ; raise Oauth2FitbitRails::Errors::BadRequest,      "400 #{response.error_message}"
        when 404 ; raise Oauth2FitbitRails::Errors::NotFound,        "404 #{response.error_message}"
        when 409 ; raise Oauth2FitbitRails::Errors::Conflict,        "409 #{response.error_message}"
        when 500 ; raise Oauth2FitbitRails::Errors::InternalServer,  "500 #{response.error_message}"
        when 502 ; raise Oauth2FitbitRails::Errors::BadGateway,      "502 #{response.error_message}"
        when 401 ; raise Oauth2FitbitRails::Errors::Unauthorized,    "401 #{response.error_message}"
        else ; response
      end

    end

  end
end
