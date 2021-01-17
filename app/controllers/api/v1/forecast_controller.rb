module Api
  module V1
    class ForecastController < ApplicationController
      def show
        forecast = OpenStruct.new(id: nil,
                                  forecast: ForecastFacade.get_forecast(params[:location])
                                  )
        render json: ForecastSerializer.new(forecast)
      end
    end
  end
end
