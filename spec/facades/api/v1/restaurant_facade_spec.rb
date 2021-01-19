require 'rails_helper' 

RSpec.describe Api::V1::RestaurantFacade do 
  describe 'find restaurant with valid food params' do 
    it 'returns restaurant object' do 
      result = Api::V1::RestaurantFacade.find_restaurant(food)

      expect(result).to be_a(Api::V1::RestaurantFacade)
    end
  end
end
