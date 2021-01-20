module Api 
  module V1 
    class BackgroundImageController < ApplicationController
      
      def show 
        result = BackgroundImageFacade.get_image(params[:location])
        return render_error(result) if result.is_a?(Hash)
        image = OpenStruct.new(id: nil, 
                               image: result)
        render json: ImageSerializer.new(image)
      end
      

      private 
      def render_error(message)
        render json: message, status: message[:error]
      end
    end
  end
end
