class DestinationForecastSerializer
  include FastJsonapi::ObjectSerializer
  set_type :roadtrip 
  attribute :start_city do |obj|
    obj.road_trip.start_city
  end

  attribute :end_city do |obj|
    obj.road_trip.destination_city
  end

  attribute :travel_time do |obj|
    obj.road_trip.travel_time
  end

  attribute :weather_at_eta do |obj|
    obj.forecast.weather_at_eta
  end
end
