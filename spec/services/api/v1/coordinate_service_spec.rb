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

    it 'returns an error for a non-existent city', :vcr do 
      location = '#@*#%&'
      result = Api::V1::CoordinateService.get_coordinates(location)

      expect(result).to be_a(Hash)
      expect(result[:error]).to eq(400)
      expect(result[:message]).to eq("Unknown Location: #{location}")
    end

    it 'returns an error for a empty city', :vcr do 
      location = ''
      result = Api::V1::CoordinateService.get_coordinates(location)

      expect(result).to be_a(Hash)
      expect(result[:error]).to eq(400)
      expect(result[:message]).to eq(["Illegal argument from request: Insufficient info for location"])
    end
  end

  describe 'get travel info' do 
    it 'returns the parsed json for a travel between two cities' do 
      travel_params = {
        start: 'Denver,Co',
        destination: 'Boulder,CO' 
      }
      
      result = Api::V1::CoordinateService.get_travel_info(travel_params)
      dest_coords = result[:boundingBox][:ul]

      expect(result).to be_a(Hash)
      expect(result[:formattedTime]).to be_a(String)
      expect(result[:boundingBox]).to be_a(Hash)
      expect(dest_coords).to be_a(Hash)
      expect(dest_coords[:lng]).to be_a(Float)
      expect(dest_coords[:lat]).to be_a(Float)
    end
  end
end
