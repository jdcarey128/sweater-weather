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
      current = result.current_weather
      daily = result.daily_weather[0]
      hourly = result.hourly_weather[0]

      expect(result).to be_a(Api::V1::Forecast)
      expect(current).to be_a(Hash)
      expect(result.daily_weather).to be_a(Array)
      expect(result.hourly_weather).to be_a(Array)
      expect(daily).to be_a(Hash)
      expect(hourly).to be_a(Hash)

      #Check current weather format 
      expect(current[:datetime]).to be_a(Time)
      expect(current[:sunrise]).to be_a(Time)
      expect(current[:sunset]).to be_a(Time)
      expect(current[:temperature]).to be_a(Float)
      expect(current[:feels_like]).to be_a(Float)
      expect(current[:humidity]).to be_a(Numeric)
      expect(current[:uvi]).to be_a(Numeric)
      expect(current[:visibility]).to be_a(Numeric)
      expect(current[:conditions]).to be_a(String)
      expect(current[:icon]).to be_a(String)

      #Check daily weather format 
      expect(daily[:date]).to be_a(String)
      expect(daily[:sunrise]).to be_a(Time)
      expect(daily[:sunset]).to be_a(Time)
      expect(daily[:max_temp]).to be_a(Float)
      expect(daily[:min_temp]).to be_a(Float)
      expect(daily[:conditions]).to be_a(String)
      expect(daily[:icon]).to be_a(String)

      #Check hourly weather format 
      expect(hourly[:time]).to be_a(String)
      expect(hourly[:temperature]).to be_a(Float)
      expect(hourly[:wind_speed]).to be_a(String)
      expect(hourly[:wind_direction]).to be_a(String)
      expect(hourly[:conditions]).to be_a(String)
      expect(hourly[:icon]).to be_a(String)
    end
  end

  describe 'forecast facade get_forecast errors' do 
    it 'returns an error message with invalid coordinates' do 
      location = 'error,city'
      error = {:error => 400, :message => "Unknown Location: #{location}"}
      allow(Api::V1::CoordinateService).to receive(:get_coordinates).with(location).and_return(error)

      result = Api::V1::ForecastFacade.get_forecast(location)

      expect(result).to be_a(Hash)
      expect(result[:error]).to eq(400)
      expect(result[:message]).to eq("Unknown Location: #{location}")
    end

    it 'returns an error message with invalid forecast search' do 
      location = 'error,city'
      coords = {:lat=>1000001, :lng=>-104.984853}
      error = {:cod => '400', :message => "wrong latitude"}
      allow(Api::V1::CoordinateService).to receive(:get_coordinates).with(location).and_return(coords)
      allow(Api::V1::ForecastService).to receive(:get_forecast).with(coords).and_return(error)

      result = Api::V1::ForecastFacade.get_forecast(location)

      expect(result).to be_a(Hash)
      expect(result[:error]).to eq(400)
      expect(result[:message]).to eq('wrong latitude')
    end
  end

  describe 'Forecast destination forecast' do 
    it 'returns a destination forecast object' do 
      travel_params = {
        start: 'Denver,Co',
        end: 'Boulder,CO' 
      }
      result = Api::V1::ForecastFacade.destination_forecast(travel_params)

      expect(result).to be_a(Api::V1::DestinationForecast)
      expect(result.travel_time).to be_a(String)
      expect(result.forecast_summary).to be_a(String)
      expect(result.forecast_temperature).to be_a(String)
    end
  end
end
