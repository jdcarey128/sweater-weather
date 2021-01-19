module Api 
  module V1 
    class ForecastFacade 
      def self.get_forecast(location)
        coords = CoordinateService.get_coordinates(location)
        return coords if coords[:error]
        forecast = ForecastService.get_forecast(coords)
        return format_error(forecast) if forecast[:cod]
        Forecast.new(forecast) 
      end

      private 
      def self.format_error(error)
        {:error => error[:cod].to_i, :message => error[:message]}
      end
    end
  end
end
