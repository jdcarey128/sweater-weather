module Api 
  module V1 
    class ForecastController < ApplicationController 
      
      def show 
        ForecastFacade.get_forecast(params[:location])
      end
      
    end
  end
end
