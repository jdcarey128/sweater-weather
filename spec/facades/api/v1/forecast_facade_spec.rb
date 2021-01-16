require 'rails_helper' 

RSpec.describe Api::V1::ForecastFacade do 
  describe 'get_forecast()' do 
    it 'returns a forecast object' do 
      location = 'denver,co'
      coords = {:lat=>39.738453, :lng=>-104.984853}
      json = File.read('spec/fixtures/get_forecast.json')
      forecast = JSON.parse(json, symbolize_names: true)
      
      allow(Api::V1::CoordinateService).to receive(:get_coordinates).with(location).and_return(coords)
      allow(Api::V1::ForecastService).to receive(:get_forecast).with(coords).and_return(forecast)
      
      result = Api::V1::ForecastFacade.get_forecast(location)

      expect(result).to be_a(Forecast)
      expect(result.current_weather).to be_a(Hash)
      expect(result.daily_weather).to be_a(Array)
      expect(result.hourly_weather).to be_a(Array)
    end
  end
end
