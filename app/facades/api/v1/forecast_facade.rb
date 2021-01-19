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

      def self.destination_forecast(travel_params)
        travel_info = TravelService.get_travel_info(travel_params)
        coords = travel_inf0[:coords]
        ForecastService.get_forecast(coords)
        DestinationForecast.new(forecast, travel_info)
      end

      private 
      def self.format_error(error)
        {:error => error[:cod].to_i, :message => error[:message]}
      end
    end
  end
end
