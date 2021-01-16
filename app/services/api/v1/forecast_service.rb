module Api 
  module V1 
    class ForecastService
      
      def self.get_forecast(coords)
        conn = make_conn
        response = conn.get('onecall') do |req|
          req.params['lat'] = coords[:lat]
          req.params['lon'] = coords[:lng]
          req.params['exclude'] = 'minutely,alerts'
        end
        JSON.parse(response.body, symbolize_names: true)
      end

      private 
      
      def self.make_conn
        Faraday.new('https://api.openweathermap.org/data/2.5') do |conn|
          conn.params['appid'] = ENV['OPEN_WEATHER_KEY']
        end
      end
    end
  end
end
