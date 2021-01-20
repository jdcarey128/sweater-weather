module Api 
  module V1 
    class RoadTripsController < ApplicationController 
      before_action :authenticate_key

      def create 
        # Add api_key validation 
        dest_forecast = RoadTripFacade.get_roadtrip_forecast(trip_params)
        # render error if error 
        render json: DestinationForecastSerializer.new(dest_forecast)
      end
      
      private 

      def authenticate_key
        user = User.find_by(api_key: params[:api_key])
        message = 'Invalid api key'
        render_error(message) unless user 
      end

      def trip_params 
        params.permit(:origin, :destination)
      end

      def render_error(message)
        render json: {:error => 400, :message => message}, 
                      status: 400
      end
    end
  end
end
