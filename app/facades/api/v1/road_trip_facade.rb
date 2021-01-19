module Api 
  module V1 
    class  RoadTripFacade 
      
      def self.get_destination_forecast(travel_params)
        travel_info = CoordinateService.get_travel_info(travel_params)
        # Return error for invalid trip entries 
        road_trip = RoadTrip.new(travel_info)
        forecast_info = ForecastService.get_forecast(road_trip.destination_coords)
        # Return error for invalid forecast 
        forecast = Forecast.new(forecast_info, road_trip.travel_time)
        return road_trip, forecast 
      end 
      
    end
  end
end
