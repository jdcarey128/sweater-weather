class ForecastSerializer
  include FastJsonapi::ObjectSerializer
  set_type :forecast 

  attribute :current_weather do |object|
    object.forecast.current_weather
  end

  attribute :daily_weather do |object|
    object.forecast.daily_weather
  end

  attribute :hourly_weather do |object|
    object.forecast.hourly_weather
  end
end
