require 'rails_helper' 

RSpec.describe 'Destination Food and Forecast' do 
  # See rails helper for defined_headers and parse_json 
  
  describe 'with valid locations and food search' do 
    it 'responds with the forecast and restaurant for destination', :vcr do 
      # Params input 
      coords = {:lng=>-105.279266, :lat=>40.015831}
      origin = 'Denver, CO'
      destination = 'Boulder, CO'
      food = 'cheese burger'

      # Stubbed responses
      json_forecast = File.read('spec/fixtures/get_forecast.json')
      forecast_info = parse_json(json_forecast)
      json_restaurant = File.read('spec/fixtures/get_restaurant_info.json')
      restaurant = JSON.parse(json_restaurant, symbolize_names: true)
      
      allow(Api::V1::ForecastService).to receive(:get_forecast).with(coords).and_return(forecast_info)
      allow(Api::V1::RestaurantService).to receive(:find_restaurant).with(food, coords).and_return(restaurant)

      # Response 
      get "/api/v1/munchies?origin=#{origin}&destination=#{destination}&food=#{food}", headers: defined_headers
  
      expect(response.status).to eq 200
      response_body = parse_json[:data]
      attributes = response_body[:attributes]
      forecast = attributes[:forecast]
      restaurant = attributes[:restaurant]
      expect(response_body[:id]).to eq(nil)
      expect(response_body[:type]).to eq('munchie')
      expect(attributes).to be_a(Hash)
      expect(attributes[:destination_city]).to eq(destination)
      expect(attributes[:travel_time]).to be_a(String)
      expect(forecast).to be_a(Hash)
      expect(forecast[:summary]).to be_a(String)
      expect(forecast[:temperature]).to be_a(String)
      expect(restaurant[:name]).to be_a(String)
      expect(restaurant[:address]).to be_a(String)
    end
  end
end
