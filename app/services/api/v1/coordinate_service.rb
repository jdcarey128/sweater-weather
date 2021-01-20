module Api
  module V1
    class CoordinateService
      def self.get_coordinates(location)
        conn = make_conn
        response = conn.get('address') do |req|
          req.params['location'] = location
          req.params['maxResults'] = 1
        end
        return {:error => 400, :message => "Unknown Location: #{location}"} if response.body.empty?
        result = parse_json(response.body)
        return format_error(result) if result[:info][:statuscode] != 0
        result[:results][0][:locations][0][:latLng]
      end

      def self.get_travel_info(travel_params)
        resp = travel_conn.get('route') do |req|
          req.params['from'] = "#{travel_params[:origin]}"
          req.params['to'] = "#{travel_params[:destination]}"
        end
        parse_json(resp.body)[:route]
      end

      private 

      def self.format_error(error)
        {:error => error[:info][:statuscode], :message => error[:info][:messages]}
      end

      def self.parse_json(json)
        JSON.parse(json, symbolize_names: true)
      end

      def self.make_conn
        Faraday.new('http://www.mapquestapi.com/geocoding/v1') do |conn|
          conn.params['key'] = ENV['MAPQUEST_KEY']
        end
      end

      def self.travel_conn 
        Faraday.new('http://www.mapquestapi.com/directions/v2') do |conn|
          conn.params['key'] = ENV['MAPQUEST_KEY']
        end
      end
    end
  end
end
