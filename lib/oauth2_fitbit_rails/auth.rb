require 'oauth2_fitbit_rails/base'

module Oauth2FitbitRails
  class Auth < Base

    def initialize(options = {})
      @state = options[:state]
      super(options)
    end

    # SAMPLE AUTHORIZATION REQUEST
    # GET: https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=22942C&
    #       redirect_uri=http%3A%2F%2Fexample.com%2Fcallback&
    #       scope=activity%20nutrition%20heartrate
    def authorize_url
      body = { response_type: 'code', client_id: @oauth_id, redirect_uri: @redirect_uri, scope: @scope, state: @state }
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
      User.new(tokens.json_body)
    end

  end
end