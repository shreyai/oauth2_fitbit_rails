module Oauth2Rails
  class Response

    def initialize(response, options = {})
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

    def json_response
      JSON.parse @far_resp.body
    end

    def errors
      json_response['errors'][0] if status != 200
    end

    def error_message
      errors['message'] if errors
    end

  end
end