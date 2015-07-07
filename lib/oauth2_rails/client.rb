require 'base'

module Oauth2Rails
  class Client < Base

    def initialize(user)
      super
      @user = user
    end

    ##==========================================================================##
    ##                          AUTHORIZATION                                   ##
    ##==========================================================================##

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

    ##==========================================================================##
    ##                          API CALLS                                       ##
    ##==========================================================================##

    ## => PROFILE
    # https://api.fitbit.com/1/user/-/profile.json
    def profile
      User.new(api_call(@user, '/1/user/-/profile.json'))
    end

    def raw_profile
      api_call(@user,'/1/user/-/profile.json')
    end

    ## => HEART DATA
    # https://api.fitbit.com/1/user/-/activities/heart/date/today/1d.json
    def daily_heart(start_date)
      api_call(@user,"/1/user/-/activities/heart/date/#{start_date}/1d.json")
    end

    # https://api.fitbit.com/1/user/-/activities/heart/date/2015-05-07/1d/1sec/time/12:20/12:45.json
    def minute_heart(days, seconds, start_date, start_time, end_time)
      api_call(@user, "/1/user/-/activities/heart/date/#{start_date}/#{days}d/#{seconds}sec/time/#{start_time}/#{end_time}.json")
    end

    ## => SLEEP DATA
    # Simple get sleep
    def sleep(date)
      api_call(@user,"/1/user/-/sleep/date/#{date}.json")
    end

    # Sleep time series
    # /1/user/-/sleep/minutesAsleep/date/today/2010-08-27.json
    # sleep/startTime ; sleep/timeInBed ; sleep/minutesAsleep
    # sleep/awakeningsCount ; sleep/minutesAwake ; sleep/minutesToFallAsleep
    # sleep/minutesAfterWakeup ; sleep/efficiency
    def time_asleep(start_date, end_date)
      api_call(@user, "/1/user/-/sleep/minutesAsleep/date/#{start_date}/#{end_date}.json")
    end

    def sleep_start(start_date, end_date)
      api_call(@user, "/1/user/-/sleep/startTime/date/#{start_date}/#{end_date}.json")
    end

    def sleep_efficiency(start_date, end_date)
      api_call(@user, "/1/user/-/sleep/efficiency/date/#{start_date}/#{end_date}.json")
    end

    def sleep_total_time(start_date, end_date)
      api_call(@user, "/1/user/-/sleep/minutesAsleep/date/#{start_date}/#{end_date}.json")
    end

    ## => BODY INFORMATION
    def body_weight(date)
      api_call(@user,"/1/user/-/body/log/weight/date/#{date}.json")
    end

    ## => ACTIVITIES
    def recent_activites
      api_call(@user, "/1/user/-/activities/recent.json")
    end

  end
end