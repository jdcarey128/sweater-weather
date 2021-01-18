module Api 
  module V1 
    class BackgroundImageService
      def self.get_image(location)
        conn = make_conn 
        resp = conn.get('photos') do |req|
          req.params['query'] = location
          req.params['order_by'] = 'relevant'
          req.params['per_page'] = 1
        end
        parse_json(resp.body)
      end

      private 

      def self.parse_json(json)
        JSON.parse(json, symbolize_names: true)
      end

      def self.make_conn
        Faraday.new('https://api.unsplash.com/search') do |conn|
          conn.params['client_id'] = ENV['UNSPLASH_KEY']
        end
      end
    end
  end
end
