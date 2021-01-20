module Api 
  module V1 
    class  RoadTripFacade 
      
      def self.get_roadtrip_forecast(travel_params)
        road_trip = get_destination_info(travel_params)

        return impossible_route(travel_params) if road_trip.is_a?(Hash)
        
        forecast = get_destination_forecast(road_trip)
        return OpenStruct.new(id: nil, 
                              road_trip: road_trip,
                              forecast: forecast)
      end

      def self.get_destination_info(travel_params)
        travel_info = CoordinateService.get_travel_info(travel_params)
        return travel_info if travel_info[:routeError][:errorCode] == 2
        road_trip = RoadTrip.new(travel_info)
        #return error 
      end
      
      def self.get_destination_forecast(road_trip)
        forecast_info = ForecastService.get_forecast(road_trip.destination_coords)
        # Return error for invalid forecast 
        Forecast.new(forecast_info, road_trip.travel_time)
      end 

      def self.get_destination_restaurant(food, travel_params)
        road_trip = get_destination_info(travel_params)
        forecast = get_destination_forecast(road_trip)
        restaurant = find_restaurant(food, road_trip.destination_coords)
        return OpenStruct.new(id: nil, 
                              travel: road_trip, 
                              forecast: forecast,
                              restaurant: restaurant)
      end

      def self.find_restaurant(food, coords)
        restaurant_info = RestaurantService.find_restaurant(food, coords)
        Restaurant.new(restaurant_info)
      end

      def self.impossible_route(travel_params)
        OpenStruct.new(id: nil, 
                      travel_time: 'Impossible route',
                      start_city: travel_params[:origin],
                      end_city: travel_params[:destination],
                      weather_at_eta: ''
                      )
      end

    end
  end
end
