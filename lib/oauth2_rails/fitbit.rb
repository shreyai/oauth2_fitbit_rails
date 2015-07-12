require 'oauth2_rails/base'
require 'oauth2_rails/client'
require 'oauth2_rails/user'

module Oauth2Rails
  class Fitbit < Client
    ## => PROFILE
    # https://api.fitbit.com/1/user/-/profile.json
    def profile
      User.new(api_call('/1/user/-/profile.json').json_body)
    end

    def raw_profile
      api_call('/1/user/-/profile.json')
    end

    ## => HEART DATA
    # https://api.fitbit.com/1/user/-/activities/heart/date/today/1d.json
    def daily_heart(start_date)
      api_call("/1/user/-/activities/heart/date/#{start_date}/1d.json")
    end

    # https://api.fitbit.com/1/user/-/activities/heart/date/2015-05-07/1d/1sec/time/12:20/12:45.json
    def minute_heart(days, seconds, start_date, start_time, end_time)
      api_call("/1/user/-/activities/heart/date/#{start_date}/#{days}d/#{seconds}sec/time/#{start_time}/#{end_time}.json")
    end

    ## => SLEEP DATA
    # Simple get sleep
    def sleep(date)
      api_call("/1/user/-/sleep/date/#{date}.json")
    end

    # Sleep time series
    # /1/user/-/sleep/minutesAsleep/date/today/2010-08-27.json
    # sleep/startTime ; sleep/timeInBed ; sleep/minutesAsleep
    # sleep/awakeningsCount ; sleep/minutesAwake ; sleep/minutesToFallAsleep
    # sleep/minutesAfterWakeup ; sleep/efficiency
    def time_asleep(start_date, end_date)
      api_call("/1/user/-/sleep/minutesAsleep/date/#{start_date}/#{end_date}.json")
    end

    def sleep_start(start_date, end_date)
      api_call("/1/user/-/sleep/startTime/date/#{start_date}/#{end_date}.json")
    end

    def sleep_efficiency(start_date, end_date)
      api_call("/1/user/-/sleep/efficiency/date/#{start_date}/#{end_date}.json")
    end

    def sleep_total_time(start_date, end_date)
      api_call("/1/user/-/sleep/minutesAsleep/date/#{start_date}/#{end_date}.json")
    end

    ## => BODY INFORMATION
    def body_weight(date)
      api_call("/1/user/-/body/log/weight/date/#{date}.json")
    end

    ## => ACTIVITIES
    def recent_activites
      api_call("/1/user/-/activities/recent.json")
    end
  end
end