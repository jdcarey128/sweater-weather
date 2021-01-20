require 'rails_helper'

RSpec.describe 'User Road Trip' do 
  # See rails helper for defined_headers, parse_json, rt_body(*)
  
  describe 'with valid api_key and locations' do 
    it 'responds with the travel time and weather at eta', :vcr do 
      # Params setup 
      user = create(:user)
      origin = 'Denver, CO'
      destination = 'Boulder, CO'
      travel_params = {
        origin: origin,
        destination: destination
      }

      # Stubbed responses 
      json_travel = File.read('spec/fixtures/get_travel_info.json')
      travel_info = parse_json(json_travel)
      allow_any_instance_of(Api::V1::RoadTripsController).to receive(:trip_params).and_return(travel_params)
      allow(Api::V1::CoordinateService).to receive(:get_travel_info).with(travel_params).and_return(travel_info)
  
      # Request 
      body = rt_body(origin, destination, user.api_key)
      post '/api/v1/road_trip', headers: defined_headers, params: body.to_json 

      # Reponse 
      expect(response.status).to eq 200
      response_body = parse_json[:data] 
      attributes = response_body[:attributes]
      weather = attributes[:weather_at_eta]

      expect(response_body[:id]).to eq(nil)
      expect(response_body[:type]).to eq('roadtrip')
      expect(attributes).to be_a(Hash)
      expect(attributes[:start_city]).to eq(origin)
      expect(attributes[:end_city]).to eq(destination)
      expect(attributes[:travel_time]).to eq("00:35:23")
      expect(weather).to be_a(Hash)
      expect(weather[:temperature]).to be_a(Float)
      expect(weather[:conditions]).to be_a(String)
    end
  end

  describe 'with valid api_key and invalid locations' do 
    it 'responds with appropriate error message' do 
      user = create(:user)
      api_key = user.api_key

      # Missing origin 
      origin = nil
      destination = 'Boulder, CO'
  
      body = rt_body(origin, destination, api_key)
      post '/api/v1/road_trip', headers: defined_headers, params: body.to_json 
  
      expect(response.status).to eq 400
      response_body = parse_json
      expect(response_body[:message]).to eq('Missing Origin in request body')
  
      # Missing destination 
      origin = 'Denver, CO'
      destination = nil
  
      body = rt_body(origin, destination, api_key)
      post '/api/v1/road_trip', headers: defined_headers, params: body.to_json 
  
      expect(response.status).to eq 400
      response_body = parse_json
      expect(response_body[:message]).to eq('Missing Destination in request body')
  
      # Missing origin and destination
      origin = nil
      destination = nil
  
      body = rt_body(origin, destination, api_key)
      post '/api/v1/road_trip', headers: defined_headers, params: body.to_json 
  
      expect(response.status).to eq 400
      response_body = parse_json
      expect(response_body[:message]).to eq('Missing Origin, Destination in request body')
    end
  end

  describe 'with invalid api_key and invalid locations' do 
    it 'responds with an error message that api_key is invalid' do 
      api_key = 'invalid-api-key'
      origin = 'Denver, CO'
      destination = 'Boulder, CO'
      travel_params = {
        origin: origin,
        destination: destination
      }

      # Request 
      body = rt_body(origin, destination, api_key)
      post '/api/v1/road_trip', headers: defined_headers, params: body.to_json 

      expect(response.status).to eq 401
      response_body = parse_json 
      expect(response_body[:error]).to eq(401)
      expect(response_body[:message]).to eq('Invalid api key')
    end
  end

  describe 'with valid inputs but impossible locations' do 
    it 'returns response with impossible route and blank weather eta', :vcr do 
      # Input params 
      user = create(:user)
      origin = 'Denver, CO' 
      destination = 'London, England'
      travel_params = {
        origin: origin, 
        destination: destination
      }
      
      body = rt_body(origin, destination, user.api_key)
      post '/api/v1/road_trip', headers: defined_headers, params: body.to_json 

      expect(response.status).to eq 200
      response_body = parse_json 
      attributes = response_body[:data][:attributes]

      expect(attributes[:start_city]).to eq(origin)
      expect(attributes[:end_city]).to eq(destination)
      expect(attributes[:travel_time]).to eq('Impossible route')
      expect(attributes[:weather_at_eta]).to eq('')
    end
    
  end
end
