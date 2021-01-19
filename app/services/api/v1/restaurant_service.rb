module Api 
  module V1 
    class RestaurantService 

      def self.find_restaurant(food, coords)
        resp = make_conn.get('search') do |req|
          req.params['term'] = food 
          req.params['latitude'] = coords[:lat]
          req.params['longitude'] = coords[:lng]
          req.params['categories'] = 'restaurants'
          req.params['limit'] = 1
          req.params['open_now'] = true
        end
        parse_json(resp.body)[:businesses][0]
      end

      def self.make_conn
        Faraday.new('https://api.yelp.com/v3/businesses') do |conn|
          conn.authorization :Bearer, ENV['YELP_KEY']
        end
      end

      def self.parse_json(json)
        JSON.parse(json, symbolize_names: true)
      end

    end
  end
end
