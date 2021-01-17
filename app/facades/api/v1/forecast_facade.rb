module Api 
  module V1 
    class ForecastFacade 
      def self.get_forecast(location)
        return coords = CoordinateService.get_coordinates(location) if coords[:error]
        forecast = ForecastService.get_forecast(coords)
        Forecast.new(forecast)
      end
    end
  end
end
