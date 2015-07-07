module Oauth2Rails
  class Base

    def initialize(options = {})
      raise Oauth2Rails::Errors::InvalidArgument, 'Must instantiate oauth_id and oauth_secret' if options[:oauth_id].nil? && options[:oauth_secret].nil?
      @oauth_id       = options[:oauth_id]       || '229MB3'
      @oauth_secret   = options[:oauth_secret]   || '63b9c42d78061f6eec4a29e206341dc5'
      @redirect_uri   = options[:redirect_uri]   || 'http://localhost:3000/oauth2_callbacks/fitbit'
      @authorize_site = options[:authorize_site] || 'https://www.fitbit.com'
      @authorize_path = options[:authorize_path] || '/oauth2/authorize'
      @api_site       = options[:api_site]       || 'https://api.fitbit.com'
      @token_path     = options[:token_path]     || '/oauth2/token'
      @scope          = options[:scope]          || 'heartrate'
    end

    # establishes faraday connection
    def connection(url)
      Faraday.new(url: url) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
    end

    # generic call action
    def call(action, destination, options = {})
      user = options[:user]
      site = options[:site] || @@api_site

      if user
        auth_header = "Bearer #{user}"
      else
        encoded = Base64.strict_encode64("#{@@oauth_id}:#{@@oauth_secret}")
        auth_header = "Basic #{encoded}"
      end

      response = connection(site).send(action) do |req|
        req.url destination
        req.headers['Content-Type']   = 'application/x-www-form-urlencoded'
        req.headers['Authorization']  = auth_header
        req.body = options[:body]
      end

      case response.status
        when 400 ; raise FitbitOauth2::Errors::BadRequest,      "400 #{get_error_message(response)}"
        when 404 ; raise FitbitOauth2::Errors::NotFound,        "404 #{get_error_message(response)}"
        when 409 ; raise FitbitOauth2::Errors::Conflict,        "409 #{get_error_message(response)}"
        when 500 ; raise FitbitOauth2::Errors::InternalServer,  "500 #{get_error_message(response)}"
        when 502 ; raise FitbitOauth2::Errors::BadGateway,      "502 #{get_error_message(response)}"
        when 401 ; raise FitbitOauth2::Errors::Unauthorized,    "401 #{get_error_message(response)}"
        else ; return response
      end



    end

    def api_call(user,destination)
      if user.class == String
        call(:get, destination, user: user)
      else
        begin
          JSON.parse call(:get, destination, user: user.access_token).body
        rescue FitbitOauth2::Errors::Unauthorized
          refresh(user)
          JSON.parse call(:get, destination, user: user.access_token).body
        end
      end
    end

    def refresh(user)
      if user.class == String
        response = JSON.parse call(:post, "#{@@token_path}?grant_type=refresh_token&refresh_token=#{user}").body
        { access_token: response['access_token'], refresh_token: response['refresh_token'] }
      else
        response = JSON.parse call(:post, "#{@@token_path}?grant_type=refresh_token&refresh_token=#{user.refresh_token}").body
        user.update!(access_token: response['access_token'], refresh_token: response['refresh_token'])
      end
    end

  end
end