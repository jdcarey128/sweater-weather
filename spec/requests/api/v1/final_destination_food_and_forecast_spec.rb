require 'rails_helper' 

RSpec.describe 'Destination Food and Forecast' do 
  # See rails helper for defined_headers and parse_json 
  
  describe 'with valid locations and food search' do 
    it 'responds with the forecast and restaurant for destination' do 
      origin = 'Denver,Co'
      destination = 'Boulder,Co'
      food = 'cheese burger'
  
      get "/api/v1/munchies?start=#{origin}&destination=#{destination}&food=#{food}", headers: defined_headers
  
      expect(response.status).to eq 200
      response_body = parse_json[:data]
      attributes = response_body[:attributes]
      forecast = attributes[:forecast]
      restaurant = attributes[:restaurant]
      expect(response_body[:id]).to eq(nil)
      expect(response_body[:type]).to eq('munchie')
      expect(attributes).to be_a(Hash)
      expect(attributes[:destination_city]).to eq(destination)
      expect(attributes[:trave_time]).to be_a(String)
      expect(forecast).to be_a(Hash)
      expect(forecast[:summary]).to be_a(String)
      expect(forecast[:temperature]).to be_a(String)
      expect(restaurant[:name]).to be_a(String)
      expect(restaurant[:addresss]).to be_a(String)
    end
  end

  describe 'with invalid locations' do 

  end

  describe 'with invalid food search' do 

  end
end
