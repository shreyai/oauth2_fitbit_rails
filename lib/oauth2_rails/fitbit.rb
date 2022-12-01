require 'oauth2_rails/base'
require 'oauth2_rails/client'
require 'oauth2_rails/user'

module Oauth2Rails
  class Fitbit < Client
    ## => PROFILE
    # https://api.fitbit.com/1/user/-/profile.json
    def profile
      Profile.new(api_call('/1/user/-/profile.json').json_body)
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

    def activity_summary(date)
      date=date.to_date.to_s
      api_call("/1/user/-/activities/date/#{date}.json")
    end

    ## => Distance Data of Given Period
    def tracker_distance_series(from_date,to_date)
      api_call("/1/user/-/activities/tracker/distance/date/#{from_date}/#{to_date}.json")
    end

    ## => Steps Data of Given Period
    def tracker_steps_series(from_date,to_date)
      api_call("/1/user/-/activities/tracker/steps/date/#{from_date}/#{to_date}.json")
    end

    ## => Activity Calories Data of Given Period
    def tracker_activity_calories(from_date,to_date)
    	# api_call("/1/user/-/activities/calories/date/#{from_date}/#{to_date}.json")
    	api_call("/1/user/-/activities/tracker/activityCalories/date/#{from_date}/#{to_date}.json")
    end

    class FitbitDataNotFound < StandardError
    end

    def tracker_distance(date)
      json_data=activity_summary(date).json_body
      distances = json_data['summary']["distances"]
      distances.each do |data|
        if data["activity"]=="tracker"
          return data['distance'],json_data
        end
      end
      raise FitbitDataNotFound 
    end

    def distance_series(from_date,to_date)
      json_data=tracker_distance_series(from_date,to_date).json_body
      distances = json_data["activities-tracker-distance"]
      return distances,json_data
    end

    def distance_and_steps_series(from_date,to_date)
      json_data_distance=tracker_distance_series(from_date,to_date).json_body
      json_data_steps=tracker_steps_series(from_date,to_date).json_body
      raise(Oauth2Rails::Errors::BadRequest, json_data_distance['errors']) if json_data_distance['errors'].present?
      distances = json_data_distance["activities-tracker-distance"]
      steps = json_data_steps["activities-tracker-steps"]
      return distances, json_data_distance, steps, json_data_steps
    end
    
    def get_user_activity_calories(from_date,to_date)
    	json_data_calorie = tracker_activity_calories(from_date,to_date).json_body
    	return json_data_calorie["activities-tracker-activityCalories"]
    end
  end
end