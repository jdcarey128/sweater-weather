module Api
  module V1
    class CoordinateService
      def self.get_coordinates(location)
        conn = make_conn(location)
        response = conn.get('address') do |req|
          req.params['location'] = location
          req.params['maxResults'] = 1
        end
        return parse_json(response.body)[:results][0][:locations][0][:latLng] unless response.body.empty?
        {:error => 400, :message => "Unknown Location: #{location}"}
      end

      def self.parse_json(json)
        JSON.parse(json, symbolize_names: true)
      end

      def self.make_conn(location)
        Faraday.new('http://www.mapquestapi.com/geocoding/v1') do |conn|
          conn.params['key'] = ENV['MAPQUEST_KEY']
        end
      end
    end
  end
end
