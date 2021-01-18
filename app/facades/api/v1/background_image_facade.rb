module Api 
  module V1 
    class BackgroundImageFacade
      def self.get_image(location)
        image_data = BackgroundImageService.get_image(location)
        return image_data if image_data[:error]
        Image.new(image_data, location)
      end
    end
  end
end
