module Api 
  module V1 
    class Forecast 
      attr_reader :current_weather, 
                  :hourly_weather, 
                  :daily_weather
                  
      def initialize(forecast_data)
        @current_weather = format_current(forecast_data[:current])
        # @hourly_weather = format_hourly(forecast_data[:hourly])
        # @daily_weather = format_daily(forecast_data[:daily])
      end

      private 

      def format_current(current_data)
        return {
          datetime: to_time(current_data[:dt]),
          sunrise: to_time(current_data[:sunrise]),
          sunset: to_time(current_data[:sunset]),
          temperature: current_data[:temp],
          feels_like: current_data[:feels_like],
          humidity: current_data[:humidity],
          uvi: current_data[:uvi],
          visibility: current_data[:visibility],
          conditions: current_data[:weather][0][:description],
          icon: current_data[:weather][0][:icon]
        }
      end

      def to_time(num)
        Time.at(num)
        #add .to_date for just date 
      end
    end
  end
end
