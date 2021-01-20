module Api 
  module V1 
    class RoadTripsController < ApplicationController 

      def create 
        # Add api_key validation 
        dest_forecast = RoadTripFacade.get_roadtrip_forecast(trip_params)
        # render error if error 
        render json: DestinationForecastSerializer.new(dest_forecast)
      end
      
      private 

      def trip_params 
        params.permit(:origin, :destination)
      end
    end
  end
end
