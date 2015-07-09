require 'json'

module Oauth2Rails
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
      json_body['errors'][0] if status != 200
    end

    def error_message
      errors['message'] if errors
    end

    def refresh_token
      json_body['access_token']
    end

    def access_token
      json_body['access_token']
    end

  end
end