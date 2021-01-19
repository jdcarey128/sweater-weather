module Api 
  module V1 
    class RoadTripsController < ApplicationController 

      def create 
        # Add api_key validation 
        road_trip, forecast = RoadTripFacade.get_destination_forecast(trip_params)
        # render error if error 
        dest_forecast = OpenStruct.new(id: nil, 
                                       road_trip: road_trip,
                                       forecast: forecast)
        render json: DestinationForecastSerializer.new(dest_forecast)
      end
      
      private 

      def trip_params 
        params.permit(:origin, :destination)
      end
    end
  end
end
