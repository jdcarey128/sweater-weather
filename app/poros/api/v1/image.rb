module Api 
  module V1 
    class Image 
      attr_reader :image_url,
                  :author,
                  :author_url,
                  :source

      def initialize(image_data)
        @image_url = image_data[:urls][:raw]
        @author = image_data[:user][:name]
        @author_url = image_data[:user][:links][:html]
        @source = find_source(@author_url)
      end

      private 
      def find_source(image)
        image.split('com')[0] + 'com'
      end
    end
  end
end
