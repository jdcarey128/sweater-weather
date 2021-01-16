require 'rails_helper'

RSpec.describe Api::V1::Forecast do 
  it 'exists and has attributes' do 
    json = File.read('spec/fixtures/get_forecast.json')
    forecast = JSON.parse(json, symbolize_names: true)

    result = Api::V1::Forecast.new(forecast) 
    current = result.current_weather
    expect(result).to be_a(Api::V1::Forecast)

    expect(current).to be_a(Hash)
    expect(current[:datetime]).to be_a(Time)
    expect(current[:sunrise]).to be_a(Time)
    expect(current[:sunset]).to be_a(Time)
    expect(current[:temperature]).to eq(42.26)
    expect(current[:feels_like]).to eq(36.88)
    expect(current[:humidity]).to eq(44)
    expect(current[:uvi]).to eq(0.18)
    expect(current[:visibility]).to eq(10000)
    expect(current[:conditions]).to eq('clear sky')
    expect(current[:icon]).to eq('01d')

    #TODO: finish test with hourly_weather and daily_weather 
    
  end
end
