module Api 
  module V1 
    class MunchiesController < ApplicationController

      def show 
        munchie_info = RoadTripFacade.get_destination_restaurant(params[:food], travel_params)
        render json: MunchieSerializer.new(munchie_info)
      end

      private 

      def travel_params 
        params.permit(:origin, :destination)
      end
    end
  end
end
