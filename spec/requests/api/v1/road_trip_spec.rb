require 'rails_helper'

RSpec.describe 'User Road Trip' do 
  # See rails helper for defined_headers, parse_json, rt_body(*)
  
  describe 'with valid api_key and locations' do 
    it 'responds with the travel time and weather at eta' do 
      user = create(:user)
      origin = 'Denver,CO'
      destination = 'Pueblo,CO'
  
      body = rt_body(origin, destination, user.api_key)
  
      post '/api/v1/road_trip', headers: defined_headers, params: body.to_json 

      expect(response.status).to eq 200
      response_body = parse_json[:data] 
      attributes = response_body[:attributes]
      weather = attributes[:weather_at_eta]
      
      expect(response_body[:id]).to eq(nil)
      expect(response_body[:type]).to eq('roadtrip')
      expect(attributes).to be_a(Hash)
      expect(attributes[:start_city]).to eq(origin)
      expect(attributes[:end_city]).to eq(destination)
      expect(attributes[:travel_time]).to eq("time tbd")
      expect(weather).to be_a(Hash)
      expect(weather[:temperature]).to be_a(Float)
      expect(weather[:conditions]).to be_a(String)
    end
  end

  describe 'with valid api_key and invalid locations' do 

  end

  describe 'with invalid api_key and invalid locations' do 

  end
end
