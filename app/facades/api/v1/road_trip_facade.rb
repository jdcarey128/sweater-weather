module Api 
  module V1 
    class  RoadTripFacade 
      
      def self.get_roadtrip_forecast(travel_params)
        road_trip = get_destination_info(travel_params)
        forecast = get_destination_forecast(road_trip)
        return OpenStruct.new(id: nil, 
                              road_trip: road_trip,
                              forecast: forecast)
      end

      def self.get_destination_info(travel_params)
        travel_info = CoordinateService.get_travel_info(travel_params)
        RoadTrip.new(travel_info)
        #return error 
      end
      
      def self.get_destination_forecast(road_trip)
        forecast_info = ForecastService.get_forecast(road_trip.destination_coords)
        # Return error for invalid forecast 
        Forecast.new(forecast_info, road_trip.travel_time)
      end 
    end
  end
end
