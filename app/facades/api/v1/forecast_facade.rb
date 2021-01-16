module Api 
  module V1 
    class ForecastFacade 
      def self.get_forecast(location)
        coords = CoordinateService.get_coordinates(location)
        forecast = ForecastService.get_forecast(coords)
        Forecast.new(forecast)
      end
    end
  end
end
