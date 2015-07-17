module Oauth2Rails
  class Profile
    def initialize(profile)
      @profile = profile
    end

    def json_response
      @profile
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

  class User
    def initialize(auth)
      @token = auth
    end

    def json_response
      @token
    end

    def id
      @token['user_id']
    end

    def access_token
      @token['access_token']
    end

    def refresh_token
      @token['refresh_token']
    end

    def expires_every
      @token['expires_in']
    end
  end
end