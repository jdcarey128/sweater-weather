require 'rails_helper' 

RSpec.describe 'Forecast' do 
  # See rails helper for defined_headers and parse_json 
  
  describe 'with valid city,state entry' do 
    before :each do 
      coords = {:lat=>39.738453, :lng=>-104.984853}
      json = File.read('spec/fixtures/get_forecast.json')
      forecast = JSON.parse(json, symbolize_names: true)

      allow(Api::V1::CoordinateService).to receive(:get_coordinates).with('denver,co').and_return(coords)
      allow(Api::V1::ForecastService).to receive(:get_forecast).with(coords).and_return(forecast)

      get '/api/v1/forecast?location=denver,co', headers: defined_headers

      expect(response.status).to eq 200
      @response = JSON.parse(response.body) 
      @response = @response['data']
    end

    it 'returns only 3 root attributes' do 
      expect(@response['id']).to eq(nil)
      expect(@response['type']).to eq('forecast')
      expect(@response).to have_key('attributes')
    end
  
    it 'returns the current weather' do 
      current_weather = @response['attributes']['current_weather']

      # TODO with json-schema 
      # expect(current_weather).to match_response_schema('current_weather')

      # keys present
      expect(current_weather).to have_key('datetime')
      expect(current_weather['datetime']).to be_a(String)
      expect(current_weather).to have_key('sunrise')
      expect(current_weather['sunrise']).to be_a(String)
      expect(current_weather).to have_key('sunset')
      expect(current_weather['sunset']).to be_a(String)
      expect(current_weather).to have_key('temperature')
      expect(current_weather['temperature']).to be_a(Float)
      expect(current_weather).to have_key('feels_like')
      expect(current_weather['feels_like']).to be_a(Float)
      expect(current_weather).to have_key('humidity')
      expect(current_weather['humidity']).to be_a(Numeric)
      expect(current_weather).to have_key('uvi')
      expect(current_weather['uvi']).to be_a(Numeric)
      expect(current_weather).to have_key('visibility')
      expect(current_weather['visibility']).to be_a(Numeric)
      expect(current_weather).to have_key('conditions') 
      expect(current_weather['conditions']).to be_a(String)
      expect(current_weather).to have_key('icon')
      expect(current_weather['icon']).to be_a(String)

      # keys not present 
      expect(current_weather).to_not have_key('pressure')
      expect(current_weather).to_not have_key('clouds')
      expect(current_weather).to_not have_key('wind_speed')
      expect(current_weather).to_not have_key('wind_deg')
      expect(current_weather).to_not have_key('weather')
    end 
  
    it 'returns daily weather for the next 5 days' do 
      daily_weather = @response['attributes']['daily_weather'][0]

      # TODO with json-schema 
      # expect(daily_weather).to match_response_schema('daily_weather')

      # keys to be present 
      expect(daily_weather).to have_key('date')
      expect(daily_weather['date']).to be_a(String)
      expect(daily_weather).to have_key('sunrise')
      expect(daily_weather['sunrise']).to be_a(String)
      expect(daily_weather).to have_key('sunset')
      expect(daily_weather['sunset']).to be_a(String)
      expect(daily_weather).to have_key('max_temp')
      expect(daily_weather['max_temp']).to be_a(Float)
      expect(daily_weather).to have_key('min_temp')
      expect(daily_weather['min_temp']).to be_a(Float)
      expect(daily_weather).to have_key('conditions')
      expect(daily_weather['conditions']).to be_a(String)
      expect(daily_weather).to have_key('icon')
      expect(daily_weather['icon']).to be_a(String)

      # keys not to be present 
      expect(daily_weather).to_not have_key('temp')
      expect(daily_weather).to_not have_key('feels_like')
      expect(daily_weather).to_not have_key('humidity')
      expect(daily_weather).to_not have_key('dew_point')
      expect(daily_weather).to_not have_key('wind_speed')
      expect(daily_weather).to_not have_key('wind_deg')
      expect(daily_weather).to_not have_key('weather')
      expect(daily_weather).to_not have_key('pop')
      expect(daily_weather).to_not have_key('clouds')
    end
  
    it 'returns hourly weather for the next 8 hours' do 
      hourly_weather = @response['attributes']['hourly_weather'][0]

      # TODO with json-schema 
      # expect(hourly_weather).to match_response_schema('hourly_weather')

      # keys present 
      expect(hourly_weather).to have_key('time')
      expect(hourly_weather['time']).to be_a(String)
      expect(hourly_weather).to have_key('temperature')
      expect(hourly_weather['temperature']).to be_a(Float)
      expect(hourly_weather).to have_key('wind_speed')
      expect(hourly_weather['wind_speed']).to be_a(String)
      expect(hourly_weather).to have_key('wind_direction')
      expect(hourly_weather['wind_direction']).to be_a(String)
      expect(hourly_weather).to have_key('conditions')
      expect(hourly_weather['conditions']).to be_a(String)
      expect(hourly_weather).to have_key('icon')
      expect(hourly_weather['icon']).to be_a(String)

      # keys not to be present 
      expect(hourly_weather).to_not have_key('dt')
      expect(hourly_weather).to_not have_key('feels_like')
      expect(hourly_weather).to_not have_key('humidity')
      expect(hourly_weather).to_not have_key('dew_point')
      expect(hourly_weather).to_not have_key('uvi')
      expect(hourly_weather).to_not have_key('clouds')
      expect(hourly_weather).to_not have_key('weather')
      expect(hourly_weather).to_not have_key('pop')
    end 
  end

  describe 'error handling' do 
    it 'returns an error message if a bad request is made' do 
      coords = {:lat=>39.738453, :lng=>''}
      allow(Api::V1::CoordinateService).to receive(:get_coordinates).with('denver,co').and_return(coords)
      
      VCR.use_cassette('forecast_error') do 
        get '/api/v1/forecast?location=denver,co', headers: defined_headers
      end

      expect(response.status).to eq 400
      result = parse_json
      expect(result[:error]).to eq(400)
      expect(result[:message]).to be_a(String)
    end
  end
  
end 
