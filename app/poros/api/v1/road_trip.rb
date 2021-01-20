module Api 
  module V1 
    class RoadTrip 
      attr_reader :start_city,
                  :destination_city, 
                  :travel_time,
                  :destination_coords

      def initialize(travel_info)
        @start_city = format_city(travel_info[:locations][0])
        @destination_city = format_city(travel_info[:locations][-1])
        @travel_time = travel_info[:formattedTime]
        @destination_coords = travel_info[:locations][-1][:displayLatLng]
      end

      def format_city(city)
        "#{city[:adminArea5]}, #{city[:adminArea3]}"
      end
    end
  end
end
