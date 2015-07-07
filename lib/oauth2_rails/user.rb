module Oauth2Rails
  class User

    def initialize(profile_body, token_body = [])
      @token    = token_body
      @profile  = profile_body
    end

    def json_profile
      @profile
    end

    def json_tokens
      @token
    end

    def profile
      @profile
    end

    def access_token
      @token['access_token']
    end

    def refresh_token
      @token['refresh_token']
    end

    def id
      @profile['user']['encodedId']
    end

    def full_name
      @profile['user']['fullName']
    end

    def display_name
      @profile['user']['displayName']
    end

    def country
      @profile['user']['country']
    end

    def state
      @profile['user']['state']
    end

    def city
      @profile['user']['city']
    end

    def about_me
      @profile['user']['aboutMe']
    end

  end
end