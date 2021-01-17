module Api
  module V1
    class ForecastController < ApplicationController
      def show
        result = ForecastFacade.get_forecast(params[:location])
        return render_error(result) if result.is_a?(Hash)
        forecast = OpenStruct.new(id: nil,
                                  forecast: result
                                  )
        render json: ForecastSerializer.new(forecast)
      end

      private 
      def render_error(message)
        render json: message, status: message[:error]
      end
    end
  end
end
