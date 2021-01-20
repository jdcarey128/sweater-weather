require 'rails_helper' 

RSpec.describe Api::V1::RestaurantService do 
  describe 'with valid food search' do 
    it 'responds with parsed restaurant info', :vcr do 
      food = 'cheese burger' 
      coords = {:lng=>-105.279266, :lat=>40.015831}

      result = Api::V1::RestaurantService.find_restaurant(food, coords)
      location = result[:location]

      expect(result[:name]).to be_a(String)
      expect(location).to be_a(Hash)
      expect(location[:display_address]).to be_a(Array)
      expect(location[:display_address][0]).to be_a(String)
    end
  end
end
