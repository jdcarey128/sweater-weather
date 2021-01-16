require 'rails_helper' 

RSpec.describe 'Forecast' do 
  describe 'with valid user api_key' do 
    before :each do 
      coords = {:lat=>39.738453, :lng=>-104.984853}
      json = File.read('spec/fixtures/get_forecast.json')
      forecast = JSON.parse(json, symbolize_names: true)

      allow(Api::V1::CoordinateService).to receive(:get_coordinates).with('denver,co').and_return(coords)
      allow(Api::V1::ForecastService).to receive(:get_forecast).with(coords).and_return(forecast)

      headers = { 
        "Content-Type": "application/json",
        "Accept": "application/json"
      }

      get '/api/v1/forecast?location=denver,co', headers: headers
      @response = JSON.parse(response.body) 
    end

    it 'returns only 3 root attributes' do 
      expect(@response.status).to eq 200
      expect(@response['id']).to eq(null)
      expect(@response['type']).to eq('forecast')
      expect(@response).to have_key('attributes')
      #look for id, type, and attributes 
    end
  
    it 'returns the current weather' do 
      current_weather = @response['attributes']['current_weather']

      expect(current_weather).to match_response_schema('current_weather')
    end 
  
    it 'returns daily weather for the next 5 days' do 
      daily_weather = @response['attributes']['daily_weather']

      expect(daily_weather).to match_response_schema('daily_weather')
    end
  
    it 'returns hourly weather for the next 8 hours' do 
      hourly_weather = @response['attributes']['hourly_weather']

      expect(hourly_weather).to match_response_schema('hourly_weather')
    end 
  end

  describe 'with invalid user api_key' do 

  end
  
end 
