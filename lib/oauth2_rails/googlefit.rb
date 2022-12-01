require 'oauth2_rails/base'
require 'oauth2_rails/client'
require 'oauth2_rails/user'

module Oauth2Rails
  class Googlefit < Client
    
    def steps_data(start,time)
      start=start.to_f*1000*1000*1000
      start=start.to_i
      time= time.to_f*1000*1000*1000
      time=time.to_i
      api_call("/fitness/v1/users/me/dataSources/derived:com.google.step_count.delta:com.google.android.gms:estimated_steps/datasets/#{start}-#{time}").json_body
    end



    class FitbitDataNotFound < StandardError
    end

    def tracker_distance(date)
      json_data=activity_summary(date).json_body
      distances = json_data['summary']["distances"]
      distances.each do |data|
        if data["activity"]=="tracker"
          return data['distance']
        end
      end
      raise FitbitDataNotFound 
    end



  end
end