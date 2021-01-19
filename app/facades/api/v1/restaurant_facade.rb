module Api 
  module V1 
    class RestaurantFacade 
      
      def self.find_restaurant(food)
        restaurant_info = RestaurantService.find_restaurant(food)
        # Add poro 
      end
    end
  end
end
