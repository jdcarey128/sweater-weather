require 'rails_helper' 

RSpec.describe Api::V1::CoordinateService do 
  describe 'get_coordinates' do 
    it 'city input returns parsed json with lat and long coordinates for the city', :vcr do 
      result = Api::V1::CoordinateService.get_coordinates('denver')

      expect(result).to be_a(Hash)
      expect(result).to have_key(:lat)
      expect(result[:lat]).to be_a(Numeric)
      expect(result).to have_key(:lng)
      expect(result[:lng]).to be_a(Numeric)
    end

    it 'city, state input returns parsed json with lat and long coordinates for the city', :vcr do 
      result = Api::V1::CoordinateService.get_coordinates('denver,co')

      expect(result).to be_a(Hash)
      expect(result).to have_key(:lat)
      expect(result[:lat]).to be_a(Numeric)
      expect(result).to have_key(:lng)
      expect(result[:lng]).to be_a(Numeric)
    end

    xit 'returns an error for a non-existent city', :vcr do 
      result = Api::V1::CoordinateService.get_coordinates(';lkaso')


    end
  end
end
