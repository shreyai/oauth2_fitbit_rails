require 'oauth2_rails/base'
require 'oauth2_rails/user'

module Oauth2Rails
  class Client < Base

    def initialize(user)
      super
      @user = user
    end

    def api_call(destination)
      begin
        call(:get, destination, user: @user.access_token)
      rescue Oauth2Rails::Errors::Unauthorized
        refresh
        call(:get, destination, user: @user.access_token)
      end
    end

    def refresh
      response = call(:post, "#{@token_path}?grant_type=refresh_token&refresh_token=#{@user.refresh_token}")
      @user.update!(access_token: response.access_token, refresh_token: response.refresh_token)
    end

    # SAMPLE AUTHORIZATION REQUEST
    # GET: https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=22942C&
    #       redirect_uri=http%3A%2F%2Fexample.com%2Fcallback&
    #       scope=activity%20nutrition%20heartrate
    def authorize_url
      body = { response_type: 'code', client_id: @oauth_id, redirect_uri: @redirect_uri, scope: @scope }
      connection(@authorize_site).build_url(@authorize_path, body).to_s
    end

    # SAMPLE POST REQUEST
    # POST:     https://api.fitbit.com/oauth2/token
    # BODY:     client_id=22942C&grant_type=authorization_code&redirect_uri=http%3A%2F%2Fexample.com%2Fcallback&code=1234567890
    # HEADERS:  Authorization: Basic Y2xpZW50X2lkOmNsaWVudCBzZWNyZXQ=
    #           Content-Type: application/x-www-form-urlencoded
    def get_token(code)
      body = { grant_type: 'authorization_code', client_id: @oauth_id, redirect_uri: @redirect_uri, code: code }
      tokens  = call(:post, @token_path, body: body)
      profile = call(:get, '/1/user/-/profile.json', user: tokens.access_token)
      User.new(profile.json_body, tokens.json_body)
    end

  end
end