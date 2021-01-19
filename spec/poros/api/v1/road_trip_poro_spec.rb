require 'rails_helper' 

RSpec.describe Api::V1::RoadTrip do 
  it 'exists and has attributes' do 
    json = File.read('spec/fixtures/get_travel_info.json')
    travel_info = JSON.parse(json, symbolize_names: true)

    travel = Api::V1::RoadTrip.new(travel_info)

    expect(travel).to be_a(Api::V1::RoadTrip)
    expect(travel.start_city).to eq('Denver, CO')
    expect(travel.destination_city).to eq('Boulder, CO')
    expect(travel.destination_coords).to eq({lng: -105.279266, lat: 40.015831})
    expect(travel.travel_time).to eq("00:35:23")
  end
end
