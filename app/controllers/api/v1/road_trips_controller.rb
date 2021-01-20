module Api 
  module V1 
    class RoadTripsController < ApplicationController 
      before_action :check_params, :authenticate_key

      def create 
        # Add api_key validation 
        dest_forecast = RoadTripFacade.get_roadtrip_forecast(trip_params)
        # require 'pry'; binding.pry
        if dest_forecast.weather_at_eta == ''
          render json: ImpossibleRouteSerializer.new(dest_forecast)
        else
          render json: DestinationForecastSerializer.new(dest_forecast)
        end 
      end
      
      private 

      def authenticate_key
        user = User.find_by(api_key: params[:api_key])
        message = 'Invalid api key'
        render_error(message) unless user 
      end

      def check_params
        errors = [] 
        errors << 'Origin' if params[:origin].nil?
        errors << 'Destination' if params[:destination].nil?
        errors << 'Api Key' if params[:api_key].nil?
        render_error("Missing #{errors.join(', ')} in request body") unless errors.empty?
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
