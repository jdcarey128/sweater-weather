module Api 
  module V1 
    class Forecast 
      attr_reader :current_weather, 
                  :hourly_weather, 
                  :daily_weather,
                  :dir
                  
      def initialize(forecast_data)
        @current_weather = format_current(forecast_data[:current])
        @daily_weather = format_daily(forecast_data[:daily])
        @hourly_weather = format_hourly(forecast_data[:hourly])
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

      def format_daily(daily_data)
        daily_data[1..5].map do |day|
          {
            date: to_time(day[:dt]).strftime("%D"),
            sunrise: to_time(day[:sunrise]),
            sunset: to_time(day[:sunset]),
            max_temp: day[:temp][:max],
            min_temp: day[:temp][:min],
            conditions: day[:weather][0][:description],
            icon: day[:weather][0][:icon]
          }
        end
      end

      def format_hourly(hourly_data)
        hourly_data[1..8].map do |hour|
          {
            time: to_time(hour[:dt]).strftime('%T'),
            temperature: hour[:temp],
            wind_speed: "#{hour[:wind_speed]} mph",
            wind_direction: "from #{dir[wind_dir(hour[:wind_deg])]}",
            conditions: hour[:weather][0][:description], 
            icon: hour[:weather][0][:icon]
          }
        end
      end

      def to_time(num)
        Time.at(num)
      end

      def wind_dir(wind)
        ((wind % 360) / 22.5).round(0)
      end

      def dir 
        return [
          'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 
          'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW',
          'NW', 'NNW', 'N'
        ]
      end
    end
  end
end
