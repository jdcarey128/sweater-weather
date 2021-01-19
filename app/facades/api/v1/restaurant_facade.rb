module Api 
  module V1 
    class RestaurantFacade 
      
      def self.find_restaurant(food, coords)
        restaurant_info = RestaurantService.find_restaurant(food, coords)
        Restaurant.new(restaurant_info)
      end
    end
  end
end
