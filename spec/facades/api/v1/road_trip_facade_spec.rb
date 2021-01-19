require 'rails_helper' 

RSpec.describe Api::V1::RoadTripFacade do 
  describe 'Forecast destination forecast' do 
    it 'returns a destination forecast object' do 
      # Input travel params 
      travel_params = {
        origin: 'Denver,Co',
        destination: 'Boulder,CO' 
      }
      # Coords for destination (Boulder)
      coords = {:lng=>-105.279266, :lat=>40.015831}

      # Read in stubbed files 
      json_travel = File.read('spec/fixtures/get_travel_info.json')
      travel_info = parse_json(json_travel)
      json_forecast = File.read('spec/fixtures/get_forecast.json')
      forecast_info = parse_json(json_forecast)
        # Stub service responses 
      allow(Api::V1::CoordinateService).to receive(:get_travel_info).with(travel_params).and_return(travel_info)
      allow(Api::V1::ForecastService).to receive(:get_forecast).with(coords).and_return(forecast_info)
      
      # Results 
      result = Api::V1::RoadTripFacade.get_destination_forecast(travel_params)
      road_trip = result[0]
      forecast = result[1]
  
      expect(result).to be_a(Array)
      expect(road_trip).to be_a(Api::V1::RoadTrip)
      expect(forecast).to be_a(Api::V1::Forecast)
      expect(road_trip.travel_time).to be_a(String)
      expect(road_trip.destination_city).to be_a(String)
      expect(forecast.current_weather).to be_a(Hash)
      expect(forecast.current_weather[:conditions]).to be_a(String)
      expect(forecast.current_weather[:temperature]).to be_a(Float)
    end
  end
end
