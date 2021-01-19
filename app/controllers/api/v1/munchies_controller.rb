module Api 
  module V1 
    class MunchiesController < ApplicationController

      def show 
        forecast = ForecastFacade.destination_forecast(travel_params)
        restaurant = MunchiesFacade.find_restaurant(params[:food])
      end

      private 

      def travel_params 
        params.permit(:start, :end)
      end
    end
  end
end
