module Api 
  module V1 
    class Restaurant 
      attr_reader :name, 
                  :address 

      def initialize(restaurant_info)
        @name = restaurant_info[:name]
        @address = restaurant_info[:location][:display_address].join(' ')
      end
    end
  end
end
