require 'json'

module Oauth2FitbitRails
  class Response

    def initialize(response)
      @far_resp = response
    end

    def status
      @far_resp.status
    end

    def headers
      @far_resp.headers
    end

    def body
      @far_resp.body
    end

    def json_body
      JSON.parse @far_resp.body
    end

    def errors
      json_body['errors'][0] if status != 200  rescue nil
    end

    def error_message
      errors['message'] if errors  rescue nil
    end

    def refresh_token
      json_body['refresh_token']  rescue nil
    end

    def access_token
      json_body['access_token'] rescue nil
    end

    def expires_every
      json_body['expires_in'] rescue nil
    end

  end
end
