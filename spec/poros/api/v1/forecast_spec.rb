require 'rails_helper'

RSpec.describe Api::V1::Forecast do 
  it 'exists and has attributes' do 
    json = File.read('spec/fixtures/get_forecast.json')
    forecast = JSON.parse(json, symbolize_names: true)

    result = Api::V1::Forecast.new(forecast) 
    current = result.current_weather
    daily = result.daily_weather
    hourly = result.hourly_weather 
    expect(result).to be_a(Api::V1::Forecast)

    # Check current weather 
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

    # Check daily weather 
    expect(daily).to be_a(Array)
    expect(daily.length).to eq(5)
    first = daily[0]
    expect(first[:date]).to eq('01/17/21')
    expect(first[:sunrise]).to be_a(Time)
    expect(first[:sunset]).to be_a(Time)
    expect(first[:max_temp]).to eq(45.54)
    expect(first[:min_temp]).to eq(32.22)
    expect(first[:conditions]).to eq('overcast clouds')
    expect(first[:icon]).to eq('04d')
    
    # Check hourly weather 
    expect(hourly).to be_a(Array)
    expect(hourly.length).to eq(8)
    first = hourly[0]
    expect(first[:time]).to eq('17:00:00')
    expect(first[:temperature]).to eq(41.18)
    expect(first[:wind_speed]).to eq('5.12 mph')
    expect(first[:wind_direction]).to eq('from SSE')
    expect(first[:conditions]).to eq('clear sky')
    expect(first[:icon]).to eq('01d')
  end
end
