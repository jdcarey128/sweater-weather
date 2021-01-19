require 'rails_helper' 

RSpec.describe Api::V1::RestaurantFacade do 
  describe 'find restaurant with valid food params' do 
    it 'returns restaurant object', :vcr do 
      food = 'cheese burger'
      coords = {:lng=>-105.279266, :lat=>40.015831}

      result = Api::V1::RestaurantFacade.find_restaurant(food, coords)

      expect(result).to be_a(Api::V1::Restaurant)
    end
  end
end
