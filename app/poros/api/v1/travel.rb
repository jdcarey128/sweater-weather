module Api 
  module V1 
    class Travel 
      attr_reader :destination_city, 
                  :travel_time,
                  :destination_coords

      def initialize(travel_info)
        @destination_city = format_dest(travel_info[:locations][1])
        @travel_time = travel_info[:formattedTime]
        @destination_coords = travel_info[:boundingBox][:ul]
      end

      def format_dest(dest)
        "#{dest[:adminArea5]},#{dest[:adminArea3]}"
      end
    end
  end
end
