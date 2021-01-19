require 'rails_helper'

RSpec.describe Api::V1::Forecast do 
  before :each do 
    json = File.read('spec/fixtures/get_forecast.json')
    @forecast = parse_json(json)
    @result = Api::V1::Forecast.new(@forecast) 
  end

  it 'exists and has attributes' do 
    current = @result.current_weather
    daily = @result.daily_weather
    hourly = @result.hourly_weather 
    expect(@result).to be_a(Api::V1::Forecast)

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
    expect(first[:wind_direction]).to eq('SSE')
    expect(first[:conditions]).to eq('clear sky')
    expect(first[:icon]).to eq('01d')
  end

  it 'can convert wind_degree to direction' do 
    expect(@result.wind_dir(360)).to eq('N')
    expect(@result.wind_dir(10)).to eq('N')
    expect(@result.wind_dir(20)).to eq('NNE')
    expect(@result.wind_dir(50)).to eq('NE')
    expect(@result.wind_dir(70)).to eq('ENE')
    expect(@result.wind_dir(80)).to eq('E')
    expect(@result.wind_dir(110)).to eq('ESE')
    expect(@result.wind_dir(130)).to eq('SE')
    expect(@result.wind_dir(160)).to eq('SSE')
    expect(@result.wind_dir(170)).to eq('S')
    expect(@result.wind_dir(210)).to eq('SSW')
    expect(@result.wind_dir(230)).to eq('SW')
    expect(@result.wind_dir(250)).to eq('WSW')
    expect(@result.wind_dir(260)).to eq('W')
    expect(@result.wind_dir(290)).to eq('WNW')
    expect(@result.wind_dir(320)).to eq('NW')
    expect(@result.wind_dir(340)).to eq('NNW')
  end

  describe 'with eta input' do 
    it 'can display the weather at eta' do 
      json_dest = File.read('spec/fixtures/get_destination_forecast.json')
      dest_forecast = parse_json(json_dest)
      
      eta = "01:40:00"
      result = Api::V1::Forecast.new(dest_forecast, eta)
      expect(result.weather_at_eta[:temperature]).to eq(34.25)
      expect(result.weather_at_eta[:conditions]).to eq('broken clouds')

      eta = '2:40:00'
      result = Api::V1::Forecast.new(dest_forecast, eta)
      expect(result.weather_at_eta[:temperature]).to eq(29.39)
      expect(result.weather_at_eta[:conditions]).to eq('broken clouds')

      eta = '24:00:00'
      result = Api::V1::Forecast.new(dest_forecast, eta)
      expect(result.weather_at_eta[:temperature]).to eq(51.4)
      expect(result.weather_at_eta[:conditions]).to eq('clear sky')
    end
  end
end 
