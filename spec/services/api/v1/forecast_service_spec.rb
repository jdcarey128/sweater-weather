require 'rails_helper'

RSpec.describe Api::V1::ForecastService do 
  describe 'get_forecast()' do 
    it 'returns parsed json of forecast', :vcr do 
      coords = {:lat=>39.738453, :lng=>-104.984853}
      result = Api::V1::ForecastService.get_forecast(coords)

      # TODO: Ask Ian/Dionne about method below to match json schema (currently passes everything)
      # expect(result).to match_response_schema('weather_forecast')

      current = result[:current]
      hourly = result[:hourly][0]
      daily = result[:daily][0]

      expect(current).to be_a(Hash)
      expect(hourly).to be_a(Hash)
      expect(daily).to be_a(Hash)

      expect(current[:dt]).to be_a(Numeric)
      expect(current[:temp]).to be_a(Numeric)
      expect(current[:feels_like]).to be_a(Numeric)
      expect(current[:pressure]).to be_a(Numeric)
      expect(current[:humidity]).to be_a(Numeric)
      expect(current[:weather]).to be_a(Array)

      expect(hourly[:dt]).to be_a(Numeric)
      expect(hourly[:temp]).to be_a(Numeric)
      expect(hourly[:feels_like]).to be_a(Numeric)
      expect(hourly[:pressure]).to be_a(Numeric)
      expect(hourly[:humidity]).to be_a(Numeric)
      expect(hourly[:weather]).to be_a(Array)
      expect(hourly[:pop]).to be_a(Numeric)

      expect(daily[:dt]).to be_a(Numeric)
      expect(daily[:temp]).to be_a(Hash)
      expect(daily[:temp][:day]).to be_a(Numeric)
      expect(daily[:feels_like]).to be_a(Hash)
      expect(daily[:pressure]).to be_a(Numeric)
      expect(daily[:humidity]).to be_a(Numeric)
      expect(daily[:weather]).to be_a(Array)
      expect(daily[:pop]).to be_a(Numeric)
    end
  end

  describe 'get forecast errors' do 
    it 'returns an error hash for invalid coords', :vcr do 
      coords = {:lat=>1000001, :lng=>-104.984853}
      result = Api::V1::ForecastService.get_forecast(coords)

      expect(result).to be_a(Hash)
      expect(result[:cod]).to eq('400')
      expect(result[:message]).to eq('wrong latitude')
    end
  end
end
