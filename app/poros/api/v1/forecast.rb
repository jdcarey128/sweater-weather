module Api 
  module V1 
    class Forecast 
      attr_reader :current_weather, 
                  :hourly_weather, 
                  :daily_weather,
                  :weather_at_eta 
                  
      def initialize(forecast_data, time_to_eta = nil)
        @current_weather = format_current(forecast_data[:current])
        @daily_weather = format_daily(forecast_data[:daily])
        @hourly_weather = format_hourly(forecast_data[:hourly])
        @weather_at_eta = eta_weather(forecast_data, time_to_eta) unless time_to_eta.nil? 
      end

      def wind_dir(wind)
        "#{dir[(((wind % 360) / 22.5).round(0))]}"
      end

      private 

      def eta_weather(forecast, time_to_eta)
        hours, minutes, seconds = parse_time(time_to_eta)
        lapse = lapsed_time(forecast[:current][:dt], hours, minutes)
        forecast_hours = select_forecast_hours(forecast, lapse)

        if hours < 24 
          dest_forecast = forecast_hours[0]
        else 
          dest_forecast = forecast_hours[1]          
        end

        return {
          temperature: dest_forecast[:temp], 
          conditions: dest_forecast[:weather][0][:description]
        }
      end

      def parse_time(time)
        time.split(':').map { |time| time.to_i }
      end

      def lapsed_time(now, hours, minutes)
        now + (minutes * 60) + (hours * 3600)
      end

      def select_forecast_hours(forecast, lapse)
        forecast[:hourly].select do |hour|
          grab_hour(hour[:dt]) == grab_hour(lapse)
        end
      end

      def grab_hour(time)
        to_time(time).strftime('%H')
      end

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
            wind_direction: wind_dir(hour[:wind_deg]),
            conditions: hour[:weather][0][:description], 
            icon: hour[:weather][0][:icon]
          }
        end
      end

      def to_time(num)
        Time.at(num)
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
