class DestinationSerializer
  include FastJsonapi::ObjectSerializer
  set_type :munchie 

  attribute :forecast do |obj|
    {
      "summary": obj.forecast.current_weather[:conditions],
      "temperature": obj.forecast.current_weather[:temperature]
    }
  end

  attribute :destination_city do |obj|
    obj.travel.destination_city
  end
  
  attribute :travel_time do |obj|
    obj.travel.travel_time
  end

  attribute :restaurant do |obj|
    {
      "name": obj.restaurant.name,
      "address": obj.restaurant.address
    }
  end
end
