module Api 
  module V1 
    class MunchiesController < ApplicationController

      def show 
        travel, forecast = RoadTripFacade.get_destination_forecast(travel_params)
        restaurant = RestaurantFacade.find_restaurant(params[:food], travel.destination_coords)
        destination = OpenStruct.new(id: nil, 
                                     travel: travel, 
                                     forecast: forecast,
                                     restaurant: restaurant)
        render json: MunchieSerializer.new(destination)
      end

      private 

      def travel_params 
        params.permit(:start, :destination)
      end
    end
  end
end
