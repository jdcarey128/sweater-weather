class ForecastSerializer
  include FastJsonapi::ObjectSerializer
  set_type :forecast 

  attribute :current_weather do |obj|
    obj.forecast.current_weather
  end

  attribute :daily_weather do |obj|
    obj.forecast.daily_weather
  end

  attribute :hourly_weather do |obj|
    obj.forecast.hourly_weather
  end
end
